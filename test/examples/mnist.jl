function test_mnist(α::Float64 = 0.9)
    trainset = MNIST(Int, :train)
    testset  = MNIST(Int, :test)

    x = [trainset[i][:features] for i = 1:60_000]
    y = [trainset[i][:targets] for i = 1:60_000]

    x̂ = [testset[i][:features] for i = 1:10_000]
    ŷ = [testset[i][:targets] for i = 1:10_000]

    @testset "MNIST ≥$α" begin
        wnn = WNN{Int,UInt64}(28, 28)

        train!.(wnn, x, y)

        @test (sum(classify.(wnn, x̂) .== ŷ) / 10_000) >= α
    end

    return nothing
end