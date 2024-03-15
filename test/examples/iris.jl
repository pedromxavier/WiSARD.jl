using DataFrames
using MLDatasets: Iris

function test_iris(α::Float64 = 0.85, β::Float64 = 6 / 7, δ::Float64 = 1E-1, k::Integer = 10)
    dataset = Iris(; as_df = true)
    N, M    = size(dataset.features)
    a       = [minimum(dataset.features[!, i]) for i = 1:M]
    b       = [maximum(dataset.features[!, i]) for i = 1:M]
    n       = trunc(Int, N * β)
    n̂       = N - n

    trainset = dataset[n̂+1:N]
    testset  = dataset[1:n̂]

    x = [collect(Float64, trainset[:features][i, :]) for i = 1:n]
    y = collect(String, trainset[:targets][!, 1])

    x̂ = [collect(Float64, testset[:features][i, :]) for i = 1:n̂]
    ŷ = collect(String, testset[:targets][!, 1])

    # Encode
    f = (x) -> ((x - a) ./ (b - a))
    τ = thermometer(f, 8)

    z = τ.(x)
    ẑ = τ.(x̂)

    @testset "Iris ≥$α" begin
        α⃗ = Vector{Float64}(undef, k)

        for j = 1:k
            wnn = WNN{String,UInt64}(8, 4; seed=j)

            train!.(wnn, z, y)

            ȳ    = classify.(wnn, ẑ)
            α⃗[j] = WiSARD.accuracy(ŷ, ȳ)
        end

        ᾱ, δ̄ = mean(α⃗), std(α⃗)

        @info @sprintf("ᾱ = %.2f ± %.2f @ Iris", ᾱ, δ̄)
        @test ᾱ >= α
        @test δ̄ <= δ
    end

    return nothing
end