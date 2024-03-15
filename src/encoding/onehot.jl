export onehot, onehot!

@doc raw"""
    onehot!(y::AbstractVector{T}, x::S) where {T<:Integer,S<:Real}
    onehot!(y::AbstractMatrix{T}, x::AbstractVector{S}) where {T<:Integer,S<:Real}
""" function onehot! end

function onehot!(y::AbstractVector{T}, x::S) where {T<:Integer,S<:Real}
    n = length(y)
    k = round(Int, (n - 1) * clamp(x, zero(S), one(S))) + 1

    for i = eachindex(y)
        y[i] = ifelse(i == k, one(T), zero(T))
    end

    return nothing
end

function onehot!(y::AbstractMatrix{T}, x::AbstractVector{S}) where {T<:Integer,S<:Real}
    for i = eachindex(x)
        onehot!(view(y, i, :), x[i])
    end

    return nothing
end

@doc raw"""
    onehot([T,] x::S, n::Integer) where {T<:Integer,S<:Real}
    onehot([T,] x::AbstractVector{S}, n::Integer) where {T<:Integer,S<:Real}
""" function onehot end

function onehot(::Type{T}, x::S, n::Integer) where {T<:Integer,S<:Real}
    y = Vector{T}(undef, n)

    onehot!(y, x)

    return y
end

function onehot(::Type{T}, x::AbstractVector{S}, n::Integer) where {T<:Integer,S<:Real}
    m = length(x)
    y = Matrix{T}(undef, m, n)

    onehot!(y, x)

    return y
end

onehot(x::S, n::Integer) where {S<:Real}                 = onehot(Int, x, n)
onehot(x::AbstractVector{S}, n::Integer) where {S<:Real} = onehot(Int, x, n)

function onehot(::Type{T}, n::Integer) where {T<:Integer}
    return (x) -> onehot(T, x, n)
end

onehot(n::Integer) = onehot(Int, n)

function onehot(f::Function, ::Type{T}, n::Integer) where {T<:Integer}
    return (x) -> onehot(T, f(x), n)
end

onehot(f::Function, n::Integer) = onehot(f, Int, n)