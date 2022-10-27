export images

@inline deaddress(wnn::WNN{S,T}, k::T) where {S,T} = filter(j -> isodd(k >> (j - 1)), 1:wnn.d)

function images(
    wnn::WNN{S,T},
    y::S;
    w::Union{Int,Nothing} = nothing,
    h::Union{Int,Nothing} = nothing,
) where {S,T}
    if isnothing(w) && isnothing(h)
        w = 1
        h = wnn.n * wnn.d
    elseif isnothing(w) || isnothing(h)
        error("Both width 'w' and height 'h' must be informed, or none of them")
    end

    cls = wnn.cls[y]
    img = zeros(Int, wnn.n * wnn.d)

    M = 0

    for (w, v) in cls
        δ = wnn.n * (w.i - 1)

        for j in deaddress(wnn, w.k)
            M = max(M, img[wnn.map[δ+j]] += v)
        end
    end

    # `permutedims` is necessary since images are read
    # in column-major (FORTRAN) order
    img = permutedims(reshape(img, h, w))

    if iszero(M)
        return img
    else
        return img ./ M
    end
end

function images(
    ::Type{X},
    wnn::WNN{S,T};
    w::Union{Int,Nothing} = nothing,
    h::Union{Int,Nothing} = nothing,
) where {S,T,X}
    return Dict{S,Matrix{X}}(y => convert.(X, images(wnn, y; w = w, h = h)) for y in keys(wnn))
end

function images(wnn::WNN; w::Union{Int,Nothing} = nothing, h::Union{Int,Nothing} = nothing)
    return images(Float64, wnn; w = w, h = h)
end