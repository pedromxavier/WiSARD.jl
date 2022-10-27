# Examples

```@setup
ENV["DATADEPS_ALWAYS_ACCEPT"] = true
```

## MNIST

### Traning & Testing
```@example mnist
using WiSARD
using MLDatasets: MNIST

# pixel activation threshold
THRESHOLD = 64 # 25% of 256

# -*- Train data -*- #
trainset = MNIST(Int, :train)

n = length(trainset)
x = [trainset[i][:features] .> THRESHOLD for i = 1:n]
y = [trainset[i][:targets] for i = 1:n]

# -*- Test data -*- #
testset = MNIST(Int, :test)

n̂ = length(testset)
x̂ = [testset[i][:features] .> THRESHOLD for i = 1:n̂]
ŷ = [testset[i][:targets] for i = 1:n̂]

wnn = WNN{Int, UInt}(28, 28; seed=0)

WiSARD.classhint!(wnn, collect(0:9))

train!.(wnn, x, y)

ȳ = classify.(wnn, x̂)
α = WiSARD.accuracy(ŷ, ȳ)

println("Accuracy: $(100α)%")
```

### Mental Images
```@example mnist
using Images

img = WiSARD.images(RGB, wnn; w=28, h=28)

img[0]
```

```@example mnist
img[1]
```

```@example mnist
img[2]
```

## Fashion MNIST

### Traning & Testing
```@example fashion-mnist
using WiSARD
using MLDatasets: FashionMNIST

# pixel activation threshold
THRESHOLD = 64 # 25% of 256

# -*- Train data -*- #
trainset = FashionMNIST(Int, :train)

n = length(trainset)
x = [trainset[i][:features] .> THRESHOLD for i = 1:n]
y = [trainset[i][:targets] for i = 1:n]

# -*- Test data -*- #
testset = FashionMNIST(Int, :test)

n̂ = length(testset)
x̂ = [testset[i][:features] .> THRESHOLD for i = 1:n̂]
ŷ = [testset[i][:targets] for i = 1:n̂]

wnn = WNN{Int, UInt}(28, 28; seed=0)

train!.(wnn, x, y)

ȳ = classify.(wnn, x̂)
α = WiSARD.accuracy(ŷ, ȳ)

println("Accuracy: $(100α)%")
```

```@example fashion-mnist
using Images

img = WiSARD.images(RGB, wnn; w=28, h=28)

img[0]
```

```@example fashion-mnist
img[1]
```

```@example fashion-mnist
img[2]
```