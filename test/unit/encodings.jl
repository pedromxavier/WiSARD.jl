function test_thermometer()
    @testset "Thermometer" begin
        @test thermometer([0.2, 0.5, 0.7], 5) == [thermometer(0.2, 5); thermometer(0.5, 5); thermometer(0.7, 5)] == Bool[1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0]
    end

    return nothing
end

function test_encodings()
    @testset "Encodings" verbose=true begin
        test_thermometer()     
    end

    return nothing
end