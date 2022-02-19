module WiSARD

import Random

export WNN, train!, classify
export thermometer

@doc raw"""
    WNN{S, T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {S <: Any, T <: Union{Unsigned, BigInt}}
    WNN{T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {T <: Union{Unsigned, BigInt}}

## References:
 * [1] Carvalho, Danilo & Carneiro, Hugo & França, Felipe & Lima, Priscila. (2013). B-bleaching : Agile Overtraining Avoidance in the WiSARD Weightless Neural Classifier. 
"""
struct WNN{S <: Any, T <: Union{Unsigned, BigInt}}
    d::Int
    n::Int
    y::Vector{Bool}
    cls::Dict{S, Vector{Dict{T, Int}}}
    map::Vector{Int}

    function WNN{S, T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {S <: Any, T <: Union{Unsigned, BigInt}}
        if n <= 0 || d <= 0
            error("Values for 'd' or 'n' must be positive")
        end
    
        if T !== BigInt && d > (T.size * 8)
            error("'$T' is insufficient to guarantee 'd' addressing bits")
        end

        if seed === nothing
            seed = trunc(Int, time())
        end
    
        rng = Random.MersenneTwister(seed)
    
        return new{S, T}(
            d,
            n,
            Vector{Bool}(undef, n * d),
            Dict{S, Vector{Dict{T, Int}}}(),
            Random.shuffle(rng, 1:n * d)
        )
    end

    function WNN{T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {T <: Union{Unsigned, BigInt}}
        return WNN{Symbol, T}(d, n; seed=seed)
    end

end

Base.show(io::IO, wnn::WNN{S, T}) where {S <: Any, T <: BigInt}  = print(io, "WNN[∞ bits, $(wnn.d) × $(wnn.n)]")
Base.show(io::IO, wnn::WNN{S, T}) where {S <: Any, T <: Unsigned} = print(io, "WNN[$(T.size * 8) bits, $(wnn.d) × $(wnn.n)]")

@doc raw"""
    train!(wnn::WNN{S, T}, x::S, y::Vector{Bool}) where {S, T}

Train model with a single pair (class `x`, sample `y`)
"""
function train!(wnn::WNN{S, T}, x::S, y::Vector{Bool}) where {S, T}

    if !haskey(wnn.cls, x)
        wnn.cls[x] = Vector{Dict{T, Int}}([Dict{T, Int}() for i = 1:wnn.n])
    end

    c = wnn.cls[x]

    wnn.y[:] = y[wnn.map]

    for i = 1:wnn.n
        k = sum(wnn.y[(i - 1) * wnn.d + j] << (j - 1) for j = 1:wnn.d)
        c[i][k] = get(c[i], k, 0) + 1
    end

    nothing
end

@doc raw"""
    classify(wnn::WNN, y::Vector{Bool}; bleach=0::Int, gamma=0.5::Float)

Classifies input `y` returning some label `x`. If no training happened, `nothing` will be returned instead.
"""
function classify(wnn::WNN, y::Vector{Bool}; bleach=0::Int, gamma=0.5::Float64)

    r₁ = r₂ = 0
    x₁ = x₂ = nothing

    for x₀ in keys(wnn.cls)
        r₀ = rate(wnn, x₀, y)
        if r₀ >= r₁
            r₁, r₂ = r₀, r₁
            x₁, x₂ = x₀, x₁
        elseif r₀ > r₂
            r₂ = r₀
        end
    end
    
    if bleach == 0
        return x₁
    else
        γ = (r₁ - r₂) / r₁

        if γ >= gamma
            return x₁
        else
            r₁ = rate(wnn, x₁, y, bleach=bleach)
            r₂ = rate(wnn, x₂, y, bleach=bleach)

            if r₁ > r₂
                return x₁
            else
                return x₂
            end
        end
    end
end

"""
"""
function rate(wnn::WNN{S, T}, x::S, y::Vector{Bool}; bleach=0::Int) where {S, T}
    if !haskey(wnn.cls, x)
        return 0.0
    else
        c = wnn.cls[x]

        wnn.y[:] = y[wnn.map]
        
        return sum((get(c[i], sum(wnn.y[(i - 1) * wnn.d + j] << (j - 1) for j = 1:wnn.d), 0.0) > bleach ? 1.0 : 0.0) for i = 1:wnn.n)
    end
end

include("encoding/encoding.jl")

end # module