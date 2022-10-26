using MLDatasets: Iris

function test_iris(α::Float64 = 0.5, β::Float64 = 0.8)
    dataset = Iris(; as_df=false)
    
    N = length(dataset)
    i = shuffle(1:trunc(Int, N * β))

    trainset = dataset[i[begin:n]]
    testset  = dataset[i[n+1:end]]

    n = length(trainset)
    x = Float64[trainset[i][:features] for i = 1:n]
    y = String[trainset[i][:targets] for i = 1:n]

    n̂ = length(testset)
    x̂ = Float64[testset[i][:features] for i = 1:n̂]
    ŷ = String[testset[i][:targets] for i = 1:n̂]

    # Encode
    a = minimum.(x)
    b = maximum.(x)
    z = [thermometer(xi) for xi in x]

    @testset "Iris ≥$α" begin
        wnn = WNN{String,UInt64}(28, 28)

        WiSARD.classhint!(wnn, collect(0:9))

        train!.(wnn, x, y)

        ȳ = classify(wnn, x̂)

        @test WiSARD.accuracy(ŷ, ȳ) >= α
    end

    return nothing
end