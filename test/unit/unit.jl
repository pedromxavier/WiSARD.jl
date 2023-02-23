include("address.jl")
include("encoding.jl")
include("broadcast.jl")

function test_unit()
    @testset "Unit tests" verbose=true begin
        test_address()
        test_encoding()     
        test_broadcast()
    end

    return nothing
end