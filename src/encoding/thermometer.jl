@doc raw"""
    Thermometer()

This method is intended to be used...

````@raw html
<svg style="display: block; margin: 0 auto;" width="5em" heigth="5em">
    <circle cx="2.5em" cy="2.5em" r="2em" stroke="black" stroke-width=".1em" fill="red" />
</svg>
````

""" struct Thermometer <: Encoding end

function encode!(y::AbstractVector{T}, x::S, ::Thermometer) where {T<:Integer,S<:Real}
    n = length(y)
    k = round(Int, n * clamp(x, zero(S), one(S)))

    for i = eachindex(y)
        y[i] = ifelse(i <= k, one(T), zero(T))
    end

    return nothing
end

function thermometer end

@doc raw"""
""" struct GaussianThermometer{S<:Real} <: Encoding
    μ::S
    σ::S

    function GaussianThermometer{S}(μ::S = zero(S), σ::S = one(S)) where {S}
        return new{S}(μ, σ)
    end
end

function GaussianThermometer(μ::S, σ::S = one(S)) where {S}
    return GaussianThermometer{S}(μ, σ)
end

function GaussianThermometer()
    return GaussianThermometer(0.0)
end

function thermometer(method::GaussianThermometer{S}) where {S<:Real}
    return (x) -> (1 + erf((x - method.μ) / (√2 * method.σ))) / 2
end

function encode!(y::AbstractVector{T}, x::S, method::GaussianThermometer{S}) where {T<:Integer,S<:Real}
    encode!(thermometer(method), y, x, Thermometer())

    return nothing
end