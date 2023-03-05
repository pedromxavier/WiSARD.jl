@doc raw"""
    Gaussian{E,S}(μ::S, σ::S) where {E,S}

""" struct Gaussian{E<:Encoding,S<:Real} <: Encoding
    μ::S
    σ::S

    function Gaussian{E,S}(μ::S = zero(S), σ::S = one(S)) where {E<:Encoding,S<:Real}
        return new{S}(μ, σ)
    end
end

function encode!(y::AbstractVector{T}, x::S, e::Gaussian{E,S}) where {T<:Integer,E<:Encoding,S<:Real}
    encode!(y, x, E()) do z
        return (1 + erf((z - e.μ) / (√2 * e.σ))) / 2
    end

    return nothing
end