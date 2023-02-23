@doc raw"""
    Circular{S}() where {S}
""" struct Circular{S<:Real} <: Encoding
    ratio::S

    function Circular{S}(ratio::S) where {S}
        return new{S}(ratio)
    end
end

function Circular(ratio::S = 1/2) where {S}
    return Circular{S}(ratio)
end 

function encode!(y::AbstractVector{T}, x::S, method::Circular) where {T<:Integer,S<:Real}
    n = length(y)
    k = round(Int, n * clamp(x, zero(S), one(S)))
    l = round(Int, n * method.ratio)

    for i = eachindex(y)
        y[i] = ifelse(i <= l, one(T), zero(T))
    end

    circshift!(y, copy(y), k)

    return nothing
end
