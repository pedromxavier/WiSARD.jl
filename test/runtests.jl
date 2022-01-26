using Test
using WiSARD

function tests()
    @testset "Encoding: Thermometer" begin
        @test thermometer([0.2, 0.5, 0.7], 5) == [thermometer(0.2, 5); thermometer(0.5, 5); thermometer(0.7, 5)] == Bool[1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0]
    end
end

# Here we go!
tests()