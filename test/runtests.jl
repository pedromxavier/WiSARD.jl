using Test
using Printf
using Random
using WiSARD
using Statistics

# -*- Accept MLDatasets Downloads -*- #
ENV["DATADEPS_ALWAYS_ACCEPT"] = true

include("unit/unit.jl")
include("examples/examples.jl")

function main()
    @testset "WiSARD.jl" verbose = true begin
        test_unit()
        test_examples()
    end
end

main() # Here we go!