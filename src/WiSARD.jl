module WiSARD
    import LinearAlgebra
    import Random
    """
    WNN - Weightless Neural Network

    n::Int64 Number of RAM units
    d::Int64 RAM dimension (addressing bits)
    """

    struct WNN{T <: Core.Integer}
        d::Int64
        n::Int64
        cls::Dict{String,Vector{Dict{T,Int64}}}
        map::Array{Int64}
        pow::Array{T}
    end

    """
"""
    function WNN(d::Int, n::Int)

        if n <= 0 || d <= 0
            error("Values for 'd' or 'n' must be positive")
        end

        if d <= 32
            return WNN{UInt32}(
                UInt64(d),
                UInt64(n),
                Dict{String,Vector{Dict{UInt32,UInt32}}}(),
                Random.shuffle(1:n * d),
                UInt32(2).^Vector{UInt32}([0:d - 1...])
            )
        elseif d <= 64
            return WNN{UInt64}(
                UInt64(d),
                UInt64(n),
                Dict{String,Vector{Dict{UInt64,UInt64}}}(),
                Random.shuffle(1:n * d),
                UInt64(2).^Vector{UInt64}([0:d - 1...])
            )
        elseif d <= 128
            return WNN{UInt128}(
                UInt64(d),
                UInt64(n),
                Dict{String,Vector{Dict{Int128,UInt64}}}(),
                Random.shuffle(1:n * d),
                UInt128(2).^Vector{UInt128}([0:d - 1...])
            )
        else
            return WNN{BigInt}(
                d, 
                n,
                Dict{String,Vector{Dict{BigInt,UInt64}}}(),
                Random.shuffle(1:n * d),
                BigInt(2).^Vector{BigInt}([0:d - 1...]),
            )
        end
    end

    function train(wnn::WNN, x::String, y::Vector{Bool})

        if length(y) != wnn.d * wnn.n
            error("Input dimension mismatch")
        end

        if !haskey(wnn.cls, x)
            wnn.cls[x] = [Dict() for i = 1:wnn.n]
        end

        z = y[wnn.map]

        for (i, j) in enumerate(range(1, length=wnn.n, step=wnn.d))
            k = LinearAlgebra.dot(wnn.pow, z[j:j + wnn.d - 1])

            if !haskey(wnn.cls[x][i], k)
                wnn.cls[x][i][k] = 0
            end

            wnn.cls[x][i][k] += 1
        end;
    end

    function train(wnn::WNN, X::Vector{String}, Y::Vector{Vector{Bool}})
        if length(X) != length(Y)
            error("Length mismatch between labels and samples")
        end

        for (x, y) in zip(X, Y)
            train(wnn, x, y)
        end
    end

    function classify(wnn::WNN, y::Vector{Bool}; bleach=0::Int64, gamma=0.5::Float64)
        if length(y) != wnn.d * wnn.n
            error("Input dimension mismatch")
        end

        r₁ = r₂ = 0
        x₁ = x₂ = nothing

        for x₀ in keys(wnn.cls)
            r₀ = rate(wnn, x₀, y)
            if r₀ >= r₁
                r₁, r₂ = r₀, r₁
                x₁, x₂ = x₀, x₁
            elseif r₀ > r₂
                r₂ = r₀
            end
        end
        
        if bleach == 0
            return x₁
        else
            γ = (r₁ - r₂) / (r₁)

            if γ >= gamma
                return x₁
            else
                r₁ = rate(wnn, x₁, y, bleach=bleach)
                r₂ = rate(wnn, x₂, y, bleach=bleach)

                if r₁ > r₂
                    return x₁
                else
                    return x₂
                end
            end
        end
    end

    function rate(wnn::WNN, x::String, y::Vector{Bool}; bleach=0::Int64)::Float64
        if !haskey(wnn.cls, x)
            return 0.0
        else
            z = y[wnn.map]
            s = 0.0
            for (i, j) in enumerate(range(1, length=wnn.n, step=wnn.d))
                k = LinearAlgebra.dot(wnn.pow, z[j:j + wnn.d - 1])

                if haskey(wnn.cls[x][i], k)
                    s += Float64(wnn.cls[x][i][k] > bleach)
                end
            end
            return s
        end
    end
end

wnn = WiSARD.WNN(2, 4);
x = "x";
y = [true, true, true, true, true, false, false, true];
WiSARD.train(wnn, x, y);
WiSARD.classify(wnn, y);