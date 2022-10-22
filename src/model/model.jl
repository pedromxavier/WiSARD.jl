export WNN, train!, classify

struct WNNKEY{T<:Union{Unsigned,BigInt}}
    i::Int
    k::T

    WNNKEY{T}(i::Int, k::T) where {T} = new{T}(i, k)
end

@doc raw"""
    WNN{S, T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {S <: Any, T <: Union{Unsigned, BigInt}}
    WNN{T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {T <: Union{Unsigned, BigInt}}

## References:
 * [1] Carvalho, Danilo & Carneiro, Hugo & França, Felipe & Lima, Priscila. (2013). B-bleaching : Agile Overtraining Avoidance in the WiSARD Weightless Neural Classifier. 
"""
struct WNN{S<:Any,T<:Union{Unsigned,BigInt}}
    d::Int
    n::Int
    cls::Dict{S,Dict{WNNKEY{T},Int}}
    map::Vector{Int}

    function WNN{S,T}(
        d::Int,
        n::Int;
        seed::Union{Int,Nothing} = nothing,
    ) where {S<:Any,T<:Union{Unsigned,BigInt}}
        if n <= 0 || d <= 0
            error("Values for 'd' and 'n' must be positive")
        end

        if T !== BigInt && d > (T.size * 8)
            error("'$T' is insufficient to guarantee 'd' addressing bits")
        end

        if seed === nothing
            seed = trunc(Int, time())
        end

        rng = Random.MersenneTwister(seed)

        new{S,T}(d, n, Dict{S,Dict{WNNKEY{T},Int}}(), Random.shuffle(rng, 1:n*d))
    end

    function WNN{T}(
        d::Int,
        n::Int;
        seed::Union{Int,Nothing} = nothing,
    ) where {T<:Union{Unsigned,BigInt}}
        WNN{Symbol,T}(d, n; seed = seed)
    end

end

Base.isempty(wnn::WNN) = all(isempty.(values(wnn.cls)))

# function Base.empty!(wnn::WNN)
#     for cls in values(wnn.cls)
#         empty!.(cls)
#     end

#     return wnn
# end

Base.show(io::IO, wnn::WNN{S,T}) where {S<:Any,T<:BigInt} =
    print(io, "WNN[∞ bits, $(wnn.d) × $(wnn.n)]")
Base.show(io::IO, wnn::WNN{S,T}) where {S<:Any,T<:Unsigned} =
    print(io, "WNN[$(T.size * 8) bits, $(wnn.d) × $(wnn.n)]")

Base.Broadcast.broadcastable(wnn::WNN) = Ref(wnn)

function address(wnn::WNN{<:Any,T}, x::AbstractArray, i::Int) where {T}
    s = zero(T)

    for j = 1:wnn.d
        k = @inbounds wnn.map[(i-1)*wnn.d+j]
        s = s + @inbounds (x[k] > 0) | (1 << (j - 1))
    end

    return s
end

@doc raw"""
    train!(wnn::WNN{S, T}, x::S, y::Vector{Bool}) where {S, T}

Train model with a single pair (class `x`, sample `y`)
"""
function train!(wnn::WNN{S,T}, x::AbstractArray, y::S) where {S,T}
    if !haskey(wnn.cls, y)
        wnn.cls[y] = Dict{WNNKEY{T},Int}()
    end

    c = wnn.cls[y]

    for i = 1:wnn.n
        ω = WNNKEY{T}(i, address(wnn, x, i))
        @inbounds c[ω] = get(c, ω, 0) + 1
    end

    nothing
end

@doc raw"""
    classify(wnn::WNN, y::Vector{Bool}; bleach=0::Int, gamma=0.5::Float)

Classifies input `y` returning some label `x`. If no training happened, `nothing` will be returned instead.
"""
function classify(wnn::WNN, x::AbstractArray; bleach = 0::Int, gamma = 0.5::Float64)

    r₁ = r₂ = 0
    y₁ = y₂ = nothing

    for y₀ in keys(wnn.cls)
        r₀ = rate(wnn, y₀, x)
        if r₀ >= r₁
            r₁, r₂ = r₀, r₁
            y₁, y₂ = y₀, y₁
        elseif r₀ > r₂
            r₂ = r₀
        end
    end

    if iszero(bleach)
        return y₁
    else
        γ = (r₁ - r₂) / r₁

        if γ >= gamma
            return y₁
        else
            r₁ = rate(wnn, y₁, x; bleach = bleach)
            r₂ = rate(wnn, y₂, x; bleach = bleach)

            return r₁ > r₂ ? y₁ : y₂
        end
    end
end

function rate(
    wnn::WNN{S,T},
    y::Union{S,Nothing},
    x::AbstractArray;
    bleach = 0::Int,
) where {S,T}
    return if !haskey(wnn.cls, y)
        0.0
    else
        c = wnn.cls[y]
        s = 0.0

        for i = 1:wnn.n
            z = @inbounds get(c, (i, address(wnn, x, i)), 0)
            s = z > bleach ? s + 1.0 : s
        end

        return s
    end
end
