using DataFrames
using MLDatasets: Iris

function test_iris(α::Float64 = 0.85, β::Float64 = 6/7)
    dataset = Iris(; as_df=true)
    N, M    = size(dataset.features)
    a       = [minimum(dataset.features[!, i]) for i = 1:M]
    b       = [maximum(dataset.features[!, i]) for i = 1:M]
    n       = trunc(Int, N * β)
    n̂       = N - n
    i       = shuffle(1:N)

    trainset = dataset[i[begin:n]]
    testset  = dataset[i[n+1:end]]

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
        wnn = WNN{String,UInt64}(8, 4)

        # WiSARD.classhint!(wnn, collect(0:9))

        train!.(wnn, z, y)

        ȳ = classify.(wnn, ẑ)
        ᾱ = WiSARD.accuracy(ŷ, ȳ)
        
        @info "ᾱ = $ᾱ @ Iris"
        @test ᾱ >= α
    end

    return nothing
end