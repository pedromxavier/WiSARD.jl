function train!(wnn::WNN{S, T}, y::S, x::BitArray) where {S, T}
    train!(wnn, y, Vector{Bool}(x))
end