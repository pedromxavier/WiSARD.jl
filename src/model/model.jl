export WNN, train!, classify

@doc raw"""
    WNN{S, T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {S <: Any, T <: Union{Unsigned, BigInt}}
    WNN{T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {T <: Union{Unsigned, BigInt}}

## References:
 * [1] Carvalho, Danilo & Carneiro, Hugo & França, Felipe & Lima, Priscila. (2013). B-bleaching : Agile Overtraining Avoidance in the WiSARD Weightless Neural Classifier. 
"""
struct WNN{S <: Any, T <: Union{Unsigned, BigInt}}
    d::Int
    n::Int
    cls::Dict{S, Vector{Dict{T, Int}}}
    map::Vector{Int}

    function WNN{S, T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {S <: Any, T <: Union{Unsigned, BigInt}}
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
    
        new{S, T}(
            d,
            n,
            Dict{S, Vector{Dict{T, Int}}}(),
            Random.shuffle(rng, 1:n * d)
        )
    end

    function WNN{T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {T <: Union{Unsigned, BigInt}}
        WNN{Symbol, T}(d, n; seed=seed)
    end

end

Base.show(io::IO, wnn::WNN{S, T}) where {S <: Any, T <: BigInt}  = print(io, "WNN[∞ bits, $(wnn.d) × $(wnn.n)]")
Base.show(io::IO, wnn::WNN{S, T}) where {S <: Any, T <: Unsigned} = print(io, "WNN[$(T.size * 8) bits, $(wnn.d) × $(wnn.n)]")

function address(wnn::WNN, x::AbstractArray, i::Int)
    @inbounds sum(iszero(x[wnn.map[(i - 1) * wnn.d + j]]) ? 0 : 1 << (j - 1) for j = 1:wnn.d)
end

@doc raw"""
    train!(wnn::WNN{S, T}, x::S, y::Vector{Bool}) where {S, T}

Train model with a single pair (class `x`, sample `y`)
"""
function train!(wnn::WNN{S, T}, y::S, x::AbstractArray) where {S, T}
    if !haskey(wnn.cls, y)
        wnn.cls[y] = Dict{T, Int}[Dict{T, Int}() for i = 1:wnn.n]
    end

    cls = wnn.cls[y]

    for i = 1:wnn.n
        k = address(wnn, x, i)
        @inbounds cls[i][k] = get(cls[i], k, 0) + 1
    end

    nothing
end

@doc raw"""
    classify(wnn::WNN, y::Vector{Bool}; bleach=0::Int, gamma=0.5::Float)

Classifies input `y` returning some label `x`. If no training happened, `nothing` will be returned instead.
"""
function classify(wnn::WNN, x::AbstractArray; bleach=0::Int, gamma=0.5::Float64)

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
    
    return if bleach == 0
        y₁
    else
        γ = (r₁ - r₂) / r₁

        if γ >= gamma
            y₁
        else
            r₂ = rate(wnn, y₂, x; bleach=bleach)
            r₁ = rate(wnn, y₁, x; bleach=bleach)

            if r₁ > r₂
                y₁
            else
                y₂
            end
        end
    end
end

function rate(wnn::WNN{S, T}, y::Union{S, Nothing}, x::AbstractArray; bleach=0::Int) where {S, T}
    return if !haskey(wnn.cls, y)
        0.0
    else
        @inbounds sum(
            get(wnn.cls[y][i], address(wnn, x, i), 0) > bleach ? 1.0 : 0.0
            for i = 1:wnn.n
        )
    end
end

function train!(wnn::WNN{S, T}, y::Vector{S}, x::Vector{<:AbstractArray}) where {S, T}
    for (yᵢ, xᵢ) in zip(y, x)
        train!(wnn, yᵢ, xᵢ)
    end

    nothing
end

function classify(wnn::WNN, x::Vector{<:AbstractArray}; bleach::Int=0, gamma::Float64=0.5)
    [classify(wnn, xᵢ; bleach=bleach, gamma=gamma) for xᵢ in x]
end