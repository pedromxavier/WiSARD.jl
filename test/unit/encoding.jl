function test_encoding_onehot()
    @testset "One-Hot" begin
        @testset "Vector" begin
            @test WiSARD.encode(0.00, 5, WiSARD.OneHot()) == [1, 0, 0, 0, 0]
            @test WiSARD.encode(0.25, 5, WiSARD.OneHot()) == [0, 1, 0, 0, 0]
            @test WiSARD.encode(0.50, 5, WiSARD.OneHot()) == [0, 0, 1, 0, 0]
            @test WiSARD.encode(0.75, 5, WiSARD.OneHot()) == [0, 0, 0, 1, 0]
            @test WiSARD.encode(1.00, 5, WiSARD.OneHot()) == [0, 0, 0, 0, 1]
        end

        @testset "Matrix" begin
            @test WiSARD.encode([0.00, 0.25, 0.50, 0.75, 1.00], 5, WiSARD.OneHot()) == [
                1 0 0 0 0
                0 1 0 0 0
                0 0 1 0 0
                0 0 0 1 0
                0 0 0 0 1
            ]
        end
    end
end

function test_encoding_thermometer()
    @testset "Thermometer" begin
        @testset "Vector" begin
            @test WiSARD.encode(0.00, 4, WiSARD.Thermometer()) == [0, 0, 0, 0]
            @test WiSARD.encode(0.25, 4, WiSARD.Thermometer()) == [1, 0, 0, 0]
            @test WiSARD.encode(0.50, 4, WiSARD.Thermometer()) == [1, 1, 0, 0]
            @test WiSARD.encode(0.75, 4, WiSARD.Thermometer()) == [1, 1, 1, 0]
            @test WiSARD.encode(1.00, 4, WiSARD.Thermometer()) == [1, 1, 1, 1]
        end

        @testset "Matrix" begin
            @test WiSARD.encode([0.00, 0.25, 0.50, 0.75, 1.00], 4, WiSARD.Thermometer()) == [
                0 0 0 0
                1 0 0 0
                1 1 0 0
                1 1 1 0
                1 1 1 1
            ]
        end
    end

    return nothing
end

function test_encoding_circular()
    @testset "Circular" begin
        @testset "Vector" begin
            @test WiSARD.encode(0.00, 4, WiSARD.Circular()) == [1, 1, 0, 0]
            @test WiSARD.encode(0.25, 4, WiSARD.Circular()) == [0, 1, 1, 0]
            @test WiSARD.encode(0.50, 4, WiSARD.Circular()) == [0, 0, 1, 1]
            @test WiSARD.encode(0.75, 4, WiSARD.Circular()) == [1, 0, 0, 1]
            @test WiSARD.encode(1.00, 4, WiSARD.Circular()) == [1, 1, 0, 0]
        end

        @testset "Matrix" begin
            @test WiSARD.encode([0.00, 0.25, 0.50, 0.75, 1.00], 4, WiSARD.Circular()) == [
                1 1 0 0
                0 1 1 0
                0 0 1 1
                1 0 0 1
                1 1 0 0
            ]
        end
    end

    return nothing
end

function test_encoding()
    @testset "Encodings" verbose = true begin
        test_encoding_onehot()
        test_encoding_thermometer()
        test_encoding_circular()
    end

    return nothing
end