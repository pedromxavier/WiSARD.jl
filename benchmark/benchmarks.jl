using BenchmarkTools
using WiSARD
using MLDatasets

const SUITE = BenchmarkGroup()

# -*- MNIST -*- #
include("suites/mnist.jl")

mnist_benchmark!(SUITE)