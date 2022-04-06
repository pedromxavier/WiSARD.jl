function address(wnn::WNN{S, T}, k::T) where {S, T}
    [j for j = 1:wnn.d if (k >> (j - 1)) % 2 == 1]
end

function images(
    N::Type{<:Any},
    wnn::WNN{S, T},
    y::S;
    w::Union{Int, Nothing} = nothing,
    h::Union{Int, Nothing} = nothing,
    ) where {S, T}
    w, h = if isnothing(w) && isnothing(h)
        1, wnn.n * wnn.d
    elseif isnothing(w) || isnothing(h)
        error("Both width 'w' and height 'h' must be informed, or none of them")
    else
        w, h
    end

    cls = wnn.cls[y]
    img = zeros(Int, wnn.n * wnn.d)

    M = 0

    for i = 1:wnn.n
        for (k, v) in cls[i]
            for j in address(wnn, k)
                M = max(M, img[wnn.map[(i - 1) * wnn.n + j]] += v)
            end
        end
    end

    return if M == 0
        N[img[(i - 1) * w + j] for i=1:h, j=1:w]
    else
        N[img[(i - 1) * w + j] / M for i=1:h, j=1:w]
    end
end

function images(
    wnn::WNN{S, T},
    y::S;
    w::Union{Int, Nothing} = nothing,
    h::Union{Int, Nothing} = nothing,
    ) where{S, T}
    images(Float64, wnn, y; w=w, h=h)
end

function images(
    N::Type{<:Any},
    wnn::WNN{S, T};
    w::Union{Int, Nothing} = nothing,
    h::Union{Int, Nothing} = nothing,
    ) where {S, T}
    Dict{S, Array{N}}(y => images(N, wnn, y; w=w, h=h) for y in keys(wnn.cls))
end

function images(
    wnn::WNN;
    w::Union{Int, Nothing} = nothing,
    h::Union{Int, Nothing} = nothing,
    )
    images(Float64, wnn; w=w, h=h)
end