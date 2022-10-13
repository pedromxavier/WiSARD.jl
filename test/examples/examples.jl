include("simple.jl")
include("mnist.jl")

function test_examples()
    @testset "Examples" verbose = true begin
        test_simple()
        test_mnist()
    end

    return nothing
end