function test_simple()
    @testset "Simple Character Learning" begin
        wnn = WNN{Symbol,UInt}(3, 4)

        X = Bool[
            1 0 1
            0 1 0
            0 1 0
            1 0 1
        ]

        Y = Bool[
            1 0 1
            0 1 0
            0 1 0
            0 1 0
        ]

        Z = Bool[
            1 1 1
            0 1 1
            1 1 0
            1 1 1
        ]

        x = [X, Y, Z]
        y = [:x, :y, :z]

        train!.(wnn, x, y)

        @test classify.(wnn, x) == y
    end

    return nothing
end
