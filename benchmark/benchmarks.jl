using BenchmarkTools
using WiSARD

const SUITE = BenchmarkGroup()

# -*- MNIST -*- #
include("suites/mnist.jl")

mnist_benchmark!(SUITE)