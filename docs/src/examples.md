# Examples

```@setup
ENV["DATADEPS_ALWAYS_ACCEPT"] = true
```

## MNIST
```@example mnist
using WiSARD
using MLDatasets

wnn = WNN{Int, UInt}(28, 28; seed=0)

train_x, train_y = MNIST.traindata(Float64, dir=joinpath(@__DIR__, "data"))

train_x = Array{Bool}[train_x[:, :, i] .>= 0.5 for i = 1:60_000]

test_x, test_y = MNIST.testdata(Float64, dir=joinpath(@__DIR__, "data"))

test_x = Array{Bool}[test_x[:, :, i] .>= 0.5 for i = 1:10_000]

train!(wnn, train_y, train_x)

s = count(classify(wnn, test_x) .== test_y)

println("Accuracy: $(100. * s / 10_000)%")
```