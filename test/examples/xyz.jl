function test_xyz(α::Float64=1.0)
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
        wnn = WNN{Symbol,UInt}(3, 4)

        train!.(wnn, x, y)

        ȳ = classify.(wnn, x̂)
        ᾱ = WiSARD.accuracy(ŷ, ȳ)

        @info "ᾱ = $ᾱ @ XYZ"
        @test ᾱ >= α 
    end

    return nothing
end
