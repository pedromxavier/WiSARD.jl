@doc raw"""
    onehot(x::Float64, n::Int)
    onehot(x::Vector{Float64}, n::Int)
"""
function onehot(x::Float64, n::Int)
    y = zeros(Bool, n)
    k = trunc(Int, clamp(x, 0.0, 1.0) * n)
    y[k] = true
    return y
end

function onehot(x::Vector{Float64}, n::Int)
    m = length(x)
    y = zeros(Bool, m * n)
    for i = 1:m
        j = (i - 1) * n + 1
        k = trunc(Int, clamp(x[i], 0.0, 1.0) * n) - 1
        y[j + k] = true
    end
    return y
end