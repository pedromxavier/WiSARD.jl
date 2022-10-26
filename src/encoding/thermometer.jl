export thermometer, thermometer!

@doc raw"""
    thermometer!(y::AbstractVector{T}, x::S) where {T<:Integer,S<:Real}
    thermometer!(y::AbstractMatrix{T}, x::AbstractVector{S}) where {T<:Integer,S<:Real}
""" function thermometer! end

function thermometer!(y::AbstractVector{T}, x::S) where {T<:Integer,S<:Real}
    n = length(y)
    k = round(Int, n * clamp(x, zero(S), one(S)))

    for i = eachindex(y)
        y[i] = ifelse(i <= k, one(T), zero(T))
    end

    return nothing
end

function thermometer!(y::AbstractMatrix{T}, x::AbstractVector{S}) where {T<:Integer,S<:Real}
    for i = eachindex(x)
        thermometer!(view(y, i, :), x[i])
    end

    return nothing
end

@doc raw"""
    thermometer([T,] x::S, n::Integer) where {T<:Integer,S<:Real}
    thermometer([T,] x::AbstractVector{S}, n::Integer) where {T<:Integer,S<:Real}
""" function thermometer end

function thermometer(::Type{T}, x::S, n::Integer) where {T<:Integer,S<:Real}
    y = Vector{T}(undef, n)

    thermometer!(y, x)

    return y
end

function thermometer(::Type{T}, x::AbstractVector{S}, n::Integer) where {T<:Integer,S<:Real}
    m = length(x)
    y = Matrix{T}(undef, m, n)

    thermometer!(y, x)

    return y
end

thermometer(x::S, n::Integer) where {S<:Real}                 = thermometer(Int, x, n)
thermometer(x::AbstractVector{S}, n::Integer) where {S<:Real} = thermometer(Int, x, n)