export circular, circular!

@doc raw"""
    circular!(y::AbstractVector{T}, x::S) where {T<:Integer,S<:Real}
    circular!(y::AbstractMatrix{T}, x::AbstractVector{S}) where {T<:Integer,S<:Real}
""" function circular! end

function circular!(y::AbstractVector{T}, x::S, l::Integer) where {T<:Integer,S<:Real}
    n = length(y)
    k = round(Int, n * clamp(x, zero(S), one(S)))

    for i = eachindex(y)
        y[i] = ifelse(i <= l, one(T), zero(T))
    end

    circshift!(y, copy(y), k)

    return nothing
end

function circular!(y::AbstractMatrix{T}, x::AbstractVector{S}, l::Integer) where {T<:Integer,S<:Real}
    for i = eachindex(x)
        circular!(view(y, i, :), x[i], l)
    end

    return nothing
end

@doc raw"""
    circular([T,] x::S, n::Integer) where {T<:Integer,S<:Real}
    circular([T,] x::AbstractVector{S}, n::Integer) where {T<:Integer,S<:Real}
""" function circular end

function circular(::Type{T}, x::S, n::Integer, l::Integer = n ÷ 2) where {T<:Integer,S<:Real}
    y = Vector{T}(undef, n)

    circular!(y, x, l)

    return y
end

function circular(::Type{T}, x::AbstractVector{S}, n::Integer, l::Integer = n ÷ 2) where {T<:Integer,S<:Real}
    m = length(x)
    y = Matrix{T}(undef, m, n)

    circular!(y, x, l)

    return y
end

circular(x::S, n::Integer, l::Integer = n ÷ 2) where {S<:Real}                 = circular(Int, x, n, l)
circular(x::AbstractVector{S}, n::Integer, l::Integer = n ÷ 2) where {S<:Real} = circular(Int, x, n, l)

function circular(::Type{T}, n::Integer, l::Integer) where {T<:Integer}
    return (x) -> circular(T, x, n, l)
end

circular(n::Integer, l::Integer) = circular(Int, n, l)

function circular(f::Function, ::Type{T}, n::Integer, l::Integer) where {T<:Integer}
    return (x) -> circular(T, f(x), n, l)
end

circular(f::Function, n::Integer, l::Integer) = circular(f, Int, n, l)