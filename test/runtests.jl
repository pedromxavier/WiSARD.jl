using Test
using WiSARD

function tests()
    @testset "Encoding: Thermometer" begin
        @test thermometer([0.2, 0.5, 0.7], 5) == [thermometer(0.2, 5); thermometer(0.5, 5); thermometer(0.7, 5)] == Bool[1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0]
    end

    @testset "Simple Character Learning" begin
        wnn = WNN{Symbol, UInt}(3, 4)

        X = Bool[1, 0, 1,
                 0, 1, 0,
                 0, 1, 0,
                 1, 0, 1,]

        Y = Bool[1, 0, 1,
                 0, 1, 0,
                 0, 1, 0,
                 0, 1, 0,]

        Z = Bool[1, 1, 1,
                 0, 1, 1,
                 1, 1, 0,
                 1, 1, 1,]
        

        train!(wnn, :x, X)
        train!(wnn, :y, Y)
        train!(wnn, :z, Z)

        @test classify(wnn, X) == :x
        @test classify(wnn, Y) == :y
        @test classify(wnn, Z) == :z
    end
end

# Here we go!
tests()