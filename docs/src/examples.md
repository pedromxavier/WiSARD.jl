# Examples

```@setup
ENV["DATADEPS_ALWAYS_ACCEPT"] = true
```

## MNIST

### Traning & Testing
```@example mnist
using WiSARD
using MLDatasets

wnn = WNN{Int, UInt}(28, 28; seed=0)

train_x, train_y = MNIST.traindata(
    Float64;
    dir=joinpath(@__DIR__, "data", "mnist")
)

train_x = Array{Bool}[train_x[:, :, i] .>= 0.25 for i = 1:60_000]

test_x, test_y = MNIST.testdata(
    Float64;
    dir=joinpath(@__DIR__, "data", "mnist")
)

test_x = Array{Bool}[test_x[:, :, i] .>= 0.25 for i = 1:10_000]

train!(wnn, train_y, train_x)

s = count(classify(wnn, test_x) .== test_y)

println("Accuracy: $(100. * s / 10_000)%")
```

```@example mnist
using Images

images = WiSARD.images(wnn)

img = images[0]

RGB.([img[(i - 1) * 28 + j] for i = 1:28, j = 1:28])
```

```@example mnist
img = images[1]

RGB.([img[(i - 1) * 28 + j] for i = 1:28, j = 1:28])
```

```@example mnist
img = images[2]

RGB.([img[(i - 1) * 28 + j] for i = 1:28, j = 1:28])
```

## Fashion MNIST
```@example fashion-mnist
using WiSARD
using MLDatasets

wnn = WNN{Int, UInt}(28, 28; seed=0)

train_x, train_y = FashionMNIST.traindata(
    Float64;
    dir=joinpath(@__DIR__, "data", "fashion-mnist")
)

train_x = Array{Bool}[train_x[:, :, i] .>= 0.25 for i = 1:60_000]

test_x, test_y = FashionMNIST.testdata(
    Float64;
    dir=joinpath(@__DIR__, "data", "fashion-mnist")
)

test_x = Array{Bool}[test_x[:, :, i] .>= 0.25 for i = 1:10_000]

train!(wnn, train_y, train_x)

s = count(classify(wnn, test_x) .== test_y)

println("Accuracy: $(100. * s / 10_000)%")
```

```@example fashion-mnist
using Images

images = WiSARD.images(wnn)

img = images[0]

RGB.([img[(i - 1) * 28 + j] for i = 1:28, j = 1:28])
```

```@example fashion-mnist
img = images[1]

RGB.([img[(i - 1) * 28 + j] for i = 1:28, j = 1:28])
```

```@example fashion-mnist
img = images[2]

RGB.([img[(i - 1) * 28 + j] for i = 1:28, j = 1:28])
```