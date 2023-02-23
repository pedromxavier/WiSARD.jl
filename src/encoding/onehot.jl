@doc raw"""
    OneHot()
    
""" struct OneHot <: Encoding end

function encode!(y::AbstractVector{T}, x::S, ::OneHot) where {T<:Integer,S<:Real}
    n = length(y)
    k = round(Int, (n - 1) * clamp(x, zero(S), one(S))) + 1

    for i = eachindex(y)
        y[i] = ifelse(i == k, one(T), zero(T))
    end

    return nothing
end
