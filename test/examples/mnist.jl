using MLDatasets: MNIST

function test_mnist(α::Float64 = 0.9)
    trainset = MNIST(Int, :train)
    testset  = MNIST(Int, :test)

    n = length(trainset)
    x = [trainset[i][:features] for i = 1:n]
    y = [trainset[i][:targets]  for i = 1:n]

    n̂ = length(testset)
    x̂ = [testset[i][:features] for i = 1:n̂]
    ŷ = [testset[i][:targets]  for i = 1:n̂]

    @testset "MNIST ≥$α" begin
        wnn = WNN{Int,UInt64}(28, 28)

        WiSARD.classhint!(wnn, collect(0:9))

        train!.(wnn, x, y)

        ȳ = classify(wnn, x̂)

        @test WiSARD.accuracy(ŷ, ȳ) >= α
    end

    return nothing
end