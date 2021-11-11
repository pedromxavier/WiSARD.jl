module WiSARD

import LinearAlgebra
import Random

export WNN, train, classify

"""
WNN - Weightless Neural Network

n::Int64 Number of RAM units
d::Int64 RAM dimension (addressing bits)
"""
struct WNN{T <: Union{Unsigned, BigInt}}
    d::Int
    n::Int
    cls::Dict{String,Vector{Dict{T, Int}}}
    map::Array{Int}
    pow::Array{T}
end

function WNN{T}(d::Int, n::Int; seed=0::Int) where T <: Union{Unsigned, BigInt}
    if n <= 0 || d <= 0
        error("Values for 'd' or 'n' must be positive")
    end

    if T !== BigInt && d > (T.size * 8)
        error("'$T' is insufficient to guarantee 'd' addressing bits")
    end

    rng = Random.MersenneTwister(seed)

    return WNN{T}(
        d, n,
        Dict{String,Vector{Dict{T, Int}}}(),
        Random.shuffle(rng, 1:n * d),
        2 .^ Vector{T}([0:d - 1...])
        )
end

function Base.show(io::IO, wnn::WNN{T}) where T <: Union{Unsigned, BigInt}
    if T === BigInt
        b = "∞"
    else
        b = "$(T.size * 8)"
    end

    print(io, "WNN[$b bits, $(wnn.d) × $(wnn.n)]")
end

"""
    train(wnn::WNN, x::String, y::Vector{Bool})

Train model with a single pair (class `x`, sample `y`)
"""
function train(wnn::WNN, x::String, y::Vector{Bool})

    if length(y) != wnn.d * wnn.n
        error("Input dimension mismatch")
    end

    if !haskey(wnn.cls, x)
        wnn.cls[x] = [Dict() for i = 1:wnn.n]
    end

    c = wnn.cls[x]
    z = y[wnn.map]

    for (i, j) in enumerate(range(1, length=wnn.n, step=wnn.d))
        k = LinearAlgebra.dot(wnn.pow, @view z[j:j + wnn.d - 1])
        c[i][k] = get(0, c[i], k) + 1
    end;
end

"""
"""
function train(wnn::WNN, X::Vector{String}, Y::Vector{Vector{Bool}})
    if length(X) != length(Y)
        error("Length mismatch between labels and samples")
    end

    for (x, y) in zip(X, Y)
        train(wnn, x, y)
    end
end

"""
    classify(wnn::WNN, y::Vector{Bool}; bleach=0::Int64, gamma=0.5::Float64)

Classifies input `y` returning some label `x`. If no training happened, `nothing` will be returned instead.
"""
function classify(wnn::WNN, y::Vector{Bool}; bleach=0::Int64, gamma=0.5::Float64)
    if length(y) != wnn.d * wnn.n
        error("Input dimension mismatch")
    end

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
        γ = (r₁ - r₂) / (r₁)

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
function classify(wnn::WNN, Y::Vector{Vector{Bool}}; bleach=0::Int64, gamma=0.5::Float64)
    return [classify(wnn, y, bleach=bleach, gamma=gamma) for y in Y]
end

"""
"""
function rate(wnn::WNN, x::String, y::Vector{Bool}; bleach=0::Int64)::Float64
    if !haskey(wnn.cls, x)
        return 0.0
    else
        c = wnn.cls[x]
        z = y[wnn.map]
        s = 0.0
        for (i, j) in enumerate(range(1, length=wnn.n, step=wnn.d))
            k = LinearAlgebra.dot(wnn.pow, z[j:j + wnn.d - 1])
            t = get(nothing, c[i], k)
            s += Float64(t !== nothing && t > bleach)
        end
        return s
    end
end

end