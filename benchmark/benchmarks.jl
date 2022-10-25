using BenchmarkTools
using WiSARD
using MLDatasets: MNIST, FashionMNIST

const SUITE = BenchmarkGroup()

# -*- MNIST -*- #
include("suites/mnist.jl")

mnist_benchmark!(SUITE)

include("suites/fmnist.jl")

fmnist_benchmark!(SUITE)
