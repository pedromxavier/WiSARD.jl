using MLDatasets: MNIST

function test_mnist(α::Float64 = 0.9, δ::Float64 = 1E-2, k::Integer = 5)
    trainset = MNIST(Int, :train)
    testset  = MNIST(Int, :test)

    n = length(trainset)
    x = [trainset[i][:features] for i = 1:n]
    y = [trainset[i][:targets] for i = 1:n]

    n̂ = length(testset)
    x̂ = [testset[i][:features] for i = 1:n̂]
    ŷ = [testset[i][:targets] for i = 1:n̂]

    @testset "MNIST ≥$α" begin
        α⃗ = Vector{Float64}(undef, k)

        for j = 1:k
            wnn = WNN{Int,UInt64}(28, 28)

            WiSARD.classhint!(wnn, collect(0:9))

            train!.(wnn, x, y)

            ȳ    = classify.(wnn, x̂)
            α⃗[j] = WiSARD.accuracy(ŷ, ȳ)
        end 

        ᾱ, δ̄ = mean(α⃗), std(α⃗)

        @info @sprintf("ᾱ = %.2f ± %.2f @ MNIST", ᾱ, δ̄)
        @test ᾱ >= α
        @test δ̄ <= δ
    end

    return nothing
end