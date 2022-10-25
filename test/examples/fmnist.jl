function test_fmnist(α::Float64 = 0.5)
    trainset = FashionMNIST(Int, :train)
    testset  = FashionMNIST(Int, :test)

    x = [trainset[i][:features] for i = 1:60_000]
    y = [trainset[i][:targets] for i = 1:60_000]

    x̂ = [testset[i][:features] for i = 1:10_000]
    ŷ = [testset[i][:targets] for i = 1:10_000]

    @testset "FashionMNIST ≥$α" begin
        wnn = WNN{Int,UInt64}(28, 28)

        train!.(wnn, x, y)

        ȳ = classify.(wnn, x̂)

        @test WiSARD.accuracy(ŷ, ȳ) >= α
    end

    return nothing
end