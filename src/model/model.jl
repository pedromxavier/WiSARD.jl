export WNN, train!, classify

const WNNINT = Union{Unsigned,BigInt}

struct WNNKEY{T<:WNNINT}
    i::Int
    k::T

    WNNKEY{T}(i::Int, k::T) where {T<:WNNINT} = new{T}(i, k)
end

const WNNCLS{T<:WNNINT} = Dict{WNNKEY{T},Int}

@doc raw"""
    WNN{S, T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {S <: Any, T <: Union{Unsigned, BigInt}}
    WNN{T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {T <: Union{Unsigned, BigInt}}

## References:
 * [1] Carvalho, Danilo & Carneiro, Hugo & França, Felipe & Lima, Priscila. (2013). B-bleaching : Agile Overtraining Avoidance in the WiSARD Weightless Neural Classifier. 
"""
struct WNN{S<:Any,T<:WNNINT}
    d::Int
    n::Int
    cls::Dict{S,WNNCLS{T}}
    map::Vector{Int}

    function WNN{S,T}(d::Integer, n::Integer, map::Vector{Int}) where {S,T<:WNNINT}
        if n <= 0 || d <= 0
            error("Values for 'd' and 'n' must be positive")
        end

        if T !== BigInt && d > (T.size * 8)
            error("'$T' is insufficient to provide 'd' addressing bits")
        end

        cls = Dict{S,WNNCLS{T}}()

        return new{S,T}(d, n, cls, map)
    end

    function WNN{S,T}(
        d::Int,
        n::Int;
        seed::Union{Integer,Nothing} = nothing,
    ) where {S<:Any,T<:Union{Unsigned,BigInt}}
        if isnothing(seed)
            seed = trunc(Int, time())
        end

        rng = Random.MersenneTwister(seed)
        map = Random.shuffle(rng, 1:n*d)

        WNN{S,T}(d, n, map)
    end
end

WNN{S}(args...; kws...) where {S} = WNN{S,UInt}(args...; kws...)
WNN(args...; kws...)              = WNN{Any}(args...; kws...)

Base.isempty(wnn::WNN) = all(isempty.(values(wnn.cls)))

function Base.empty!(wnn::WNN)
    empty!(wnn.cls)

    return wnn
end

Base.show(io::IO, wnn::WNN{S,T}) where {S<:Any,T<:BigInt} =
    print(io, "WNN[∞ bits, $(wnn.d) × $(wnn.n)]")
Base.show(io::IO, wnn::WNN{S,T}) where {S<:Any,T<:Unsigned} =
    print(io, "WNN[$(T.size * 8) bits, $(wnn.d) × $(wnn.n)]")

Base.Broadcast.broadcastable(wnn::WNN) = Ref(wnn)

@inline function address(wnn::WNN{<:Any,T}, x::AbstractArray{<:Integer}, i::Int) where {T}
    k = zero(T)
    δ = wnn.d * (i - 1)

    @simd for j = 1:wnn.d
        k += ifelse(!iszero(@inbounds x[wnn.map[δ+j]]), one(T) << (j - 1), zero(T))
    end

    return WNNKEY{T}(i, k)
end

@doc raw"""
    train!(wnn::WNN{S, T}, x::S, y::Vector{Bool}) where {S, T}

Train model with a single pair (class `x`, sample `y`)
"""
@inline function train!(wnn::WNN{S,T}, x::AbstractArray{<:Integer}, y::S) where {S,T}
    if !haskey(wnn.cls, y)
        wnn.cls[y] = Dict{WNNKEY{T},Int}()
    end

    c = wnn.cls[y]

    @simd for i = 1:wnn.n
        ω = address(wnn, x, i)

        @inbounds c[ω] = get(c, ω, 0) + 1
    end

    return nothing
end

@doc raw"""
    classify(wnn::WNN, y::Vector{Bool}; bleach=0::Int, gamma=0.5::Float)

Classifies input `y` returning some label `x`. If no training happened, `nothing` will be returned instead.
"""
function classify(wnn::WNN, x::AbstractArray{<:Integer}; bleach = 0::Int, gamma = 0.5::Float64)
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
            r₁ = rate(wnn, y₁, x, bleach)
            r₂ = rate(wnn, y₂, x, bleach)

            return r₁ > r₂ ? y₁ : y₂
        end
    end
end

function rate(
    wnn::WNN{S,T},
    y::Union{S,Nothing},
    x::AbstractArray{<:Integer},
    bleach::Integer = 0,
) where {S,T}
    return if !haskey(wnn.cls, y)
        return 0.0
    else
        c = wnn.cls[y]
        s = 0.0

        for i = 1:wnn.n
            s += ifelse((get(c, address(wnn, x, i), 0) > bleach), 1.0, 0.0)
        end

        return s
    end
end

function classhint!(wnn::WNN{S,T}, classes::Vector{S}) where {S,T}
    for key in classes
        if !haskey(wnn.cls, key)
            wnn.cls[key] = WNNCLS{T}()
        end
    end

    return nothing
end

function classhint!(wnn::WNN{S,T}, classes::S...) where {S,T}
    classhint!(wnn, collect(classes))
end