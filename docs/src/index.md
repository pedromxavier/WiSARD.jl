# WiSARD.jl Documentation

This package implements the WiSARD (*Wilkie, Stoneham and Aleksander Recognition Device*) Weightless Neural Network Model, a lightning-fast classifier over binary data.

## Quick Start

### Installation
```julia
pkg> add WiSARD
```
or
```julia
julia> import Pkg

julia> Pkg.add("WiSARD")
```

### Example
```julia
using WiSARD

wnn = WNN{Symbol, UInt}(2, 2)

train!(wnn, :x, [1 1 0 0])
train!(wnn, :y, [0 0 1 1])

classify(wnn, [1 1 0 0]) == :x
```

### Citing WiSARD.jl
```tex
@software{
    author={{Pedro Maciel Xavier}},
    title={{WiSARD.jl}},
    url = {https://github.com/pedromxavier/WiSARD.jl},
    version = {0.1.1},
    date = {2022-04-01},
}
```