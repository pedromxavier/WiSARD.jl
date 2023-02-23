function encode!(
    y::AbstractMatrix{T},
    x::AbstractVector{S},
    method::Encoding,
) where {T<:Integer,S<:Real}
    for i in eachindex(x)
        encode!(view(y, i, :), x[i], method)
    end

    return nothing
end

function encode!(
    f::Function,
    y::AbstractVector{T},
    x::S,
    method::Encoding,
) where {T<:Integer,S<:Real}
    encode!(y, f(x), method)

    return nothing
end

function encode(::Type{T}, x::S, n::Integer, method::Encoding) where {T<:Integer,S<:Real}
    y = Vector{T}(undef, n)

    encode!(y, x, method)

    return y
end

function encode(
    ::Type{T},
    x::AbstractVector{S},
    n::Integer,
    method,
) where {T<:Integer,S<:Real}
    m = length(x)
    y = Matrix{T}(undef, m, n)

    encode!(y, x, method)

    return y
end

function encode(x::S, n::Integer, method::Encoding) where {S<:Real}
    return encode(Int, x, n, method)
end

function encode(x::AbstractVector{S}, n::Integer, method::Encoding) where {S<:Real}
    return encode(Int, x, n, method)
end

function encode(::Type{T}, n::Integer, method::Encoding) where {T<:Integer}
    return (x) -> encode(T, x, n, method)
end

function encode(n::Integer, method::Encoding)
    return encode(Int, n, method)
end

function encode(f::Function, ::Type{T}, n::Integer, method::Encoding) where {T<:Integer}
    return (x) -> encode(T, f(x), n, method)
end

function encode(f::Function, n::Integer, method::Encoding)
    return encode(f, Int, n, method)
end