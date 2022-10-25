include("address.jl")
include("encodings.jl")
include("broadcast.jl")

function test_unit()
    @testset "Unit tests" verbose=true begin
        test_address()
        test_encodings()     
        test_broadcast()
    end

    return nothing
end