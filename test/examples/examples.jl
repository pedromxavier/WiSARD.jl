include("xyz.jl")
include("mnist.jl")
include("fmnist.jl")
include("iris.jl")

function test_examples()
    @testset "Examples" verbose = true begin
        test_xyz()
        test_mnist()
        test_fmnist()
        test_iris()
    end

    return nothing
end