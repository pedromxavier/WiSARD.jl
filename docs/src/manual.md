# Manual

## WiSARD

The WiSARD (*Wilkie, Stoneham and Aleksander Recognition Device*) Weightless Neural Network Model is conceptually composed by an associative array of *discriminators* or classes. To each one is assigned a key of arbitrary type, usually some string.

Inside every discriminator lies an array with ``n`` virtual "RAM" units who act pretty much like real RAM memories. To every RAM unit are given ``d`` addressing bits.

!!! info
    In a first moment, the input dimension must match the model's dimension ``n \times d``. Also, choices made for ``n`` and ``d`` do impact the recognition performance.

During initialization, a random mapping between the network's input and the RAM addresses is defined and kept static during the whole model's lifetime.

### Training

For training, some binary pattern is written to the correspondig discriminator by incrementing the values store at the RAM addresses where the predefined mapping points to. Values from randomly gathered spots within the original input vector are grouped to form each address whose values are initially set to zero by using a sparse data structure.

### Classification

Here, the process is pretty much similar. The input is used to address the same RAM positions on every discriminator, this time reading the stored value and assigning a corresponding response rate. The greatest score indicates the chosen class.

## Interface

`WiSARD.jl`'s interface is very simple. A model is created by calling the `WNN{S, T}(n::Int, d::Int; seed::Int)` constructor, where `n` is the number of RAM units and `d` is the respective number of addressing bits. The optional parameter `seed` is used to induce a random mapping between the input and each RAM's bus.

```@docs
WiSARD.WNN

```@docs
WiSARD.train!
```

```@docs
WiSARD.classify
```

## Encoding

```@docs
WiSARD.onehot!
WiSARD.onehot
```

```@docs
WiSARD.thermometer!
WiSARD.thermometer
```

```@docs
WiSARD.circular!
WiSARD.circular
```