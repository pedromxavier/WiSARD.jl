function test_xyz(α::Float64=1.0, δ::Float64=0.0, k::Integer = 10)
    x = x̂ = [
        [
            1 0 1
            0 1 0
            0 1 0
            1 0 1
        ],
        [
            1 0 1
            0 1 0
            0 1 0
            0 1 0
        ],
        [
            1 1 1
            0 1 1
            1 1 0
            1 1 1
        ]
    ]

    y = ŷ = [:x, :y, :z]

    @testset "XYZ ≥$α" begin
        α⃗ = Vector{Float64}(undef, k)

        for j = 1:k
            wnn = WNN{Symbol,UInt64}(3, 4; seed=j)

            train!.(wnn, x, y)

            ȳ    = classify.(wnn, x̂)
            α⃗[j] = WiSARD.accuracy(ŷ, ȳ)
        end

        ᾱ, δ̄ = mean(α⃗), std(α⃗)

        @info @sprintf("ᾱ = %.2f ± %.2f @ XYZ", ᾱ, δ̄)
        @test ᾱ >= α
        @test δ̄ <= δ
    end

    return nothing
end
