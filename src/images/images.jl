function address(wnn::WNN{S, T}, k::T) where {S, T}
    [j for j = 1:wnn.d if (k >> (j - 1)) % 2 == 1]
end

function images(wnn::WNN{S, T}, y::S) where {S, T}
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
        Float64.(img)
    else
        Float64.(img ./ M)
    end
end

function images(wnn::WNN{S, T}) where {S, T}
    return Dict{S, Array{Float64}}(y => images(wnn, y) for y in keys(wnn.cls))
end