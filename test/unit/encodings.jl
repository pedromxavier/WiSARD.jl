function test_onehot()
    @testset "One-Hot" begin
        @testset "Vector" begin
            @test onehot(0.00, 5) == [1, 0, 0, 0, 0]
            @test onehot(0.25, 5) == [0, 1, 0, 0, 0]
            @test onehot(0.50, 5) == [0, 0, 1, 0, 0]
            @test onehot(0.75, 5) == [0, 0, 0, 1, 0]
            @test onehot(1.00, 5) == [0, 0, 0, 0, 1]
        end

        @testset "Matrix" begin
            @test onehot([0.00, 0.25, 0.50, 0.75, 1.00], 5) == [
                1 0 0 0 0
                0 1 0 0 0
                0 0 1 0 0
                0 0 0 1 0
                0 0 0 0 1
            ]
        end
    end
end

function test_thermometer()
    @testset "Thermometer" begin
        @testset "Vector" begin
            @test thermometer(0.00, 4) == [0, 0, 0, 0]
            @test thermometer(0.25, 4) == [1, 0, 0, 0]
            @test thermometer(0.50, 4) == [1, 1, 0, 0]
            @test thermometer(0.75, 4) == [1, 1, 1, 0]
            @test thermometer(1.00, 4) == [1, 1, 1, 1]
        end

        @testset "Matrix" begin
            @test thermometer([0.00, 0.25, 0.50, 0.75, 1.00], 4) == [
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

function test_circular()
    @testset "Circular" begin
        @testset "Vector" begin
            @test circular(0.00, 4) == [1, 1, 0, 0]
            @test circular(0.25, 4) == [0, 1, 1, 0]
            @test circular(0.50, 4) == [0, 0, 1, 1]
            @test circular(0.75, 4) == [1, 0, 0, 1]
            @test circular(1.00, 4) == [1, 1, 0, 0]
        end

        @testset "Matrix" begin
            @test circular([0.00, 0.25, 0.50, 0.75, 1.00], 4) == [
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

function test_encodings()
    @testset "Encodings" verbose=true begin
        test_onehot()
        test_thermometer()  
        test_circular()
    end

    return nothing
end