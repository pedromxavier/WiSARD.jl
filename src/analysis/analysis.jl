@doc raw"""
    accuracy(ŷ, y)
""" function accuracy end

accuracy(ŷ, ȳ) = sum(ŷ .== ȳ) / length(ŷ)