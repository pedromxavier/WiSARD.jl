# Examples

## MNIST

```@setup
ENV["DATADEPS_ALWAYS_ACCEPT"] = true
```

```@example
using WiSARD
using MLDatasets

wnn = WNN{Int, UInt}(28, 28; seed=0)

train_x, train_y = MNIST.traindata(Float64, dir=joinpath(@__DIR__, "data"))

train_x = [Vector{Bool}(reshape(train_x[:, :, i], 28 * 28) .>= 0.5) for i = 1:60_000]

test_x, test_y = MNIST.testdata(Float64, dir=joinpath(@__DIR__, "data"))

test_x = [Vector{Bool}(reshape(test_x[:, :, i], 28 * 28) .>= 0.5) for i = 1:10_000]

for (y, x) in zip(train_y, train_x)
    train!(wnn, y, x)
end

s = count(classify(wnn, x) == y for (y, x) in zip(test_y, test_x))

println("Accuracy: $(100. * s / 10_000)%")
```