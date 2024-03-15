function test_broadcast()
    wnn = WNN{Symbol,UInt}(3, 4)

    x = [
        Bool[
            1 0 1
            0 1 0
            0 1 0
            1 0 1
        ],
        Bool[
            1 0 1
            0 1 0
            0 1 0
            0 1 0
        ],
        Bool[
            1 1 1
            0 1 1
            1 1 0
            1 1 1
        ],
    ]

    y = [:x, :y, :z]

    @testset "Broadcasting" begin
        train!.(wnn, x, y)

        @test classify.(wnn, x) == y
    end

    return nothing
end