# WiSARD.jl Documentation

This package implements the WiSARD (*Wilkie, Stoneham and Aleksander Recognition Device*) Weightless Neural Network Model, a lightning-fast classifier over binary data.

## Quick Start

### Installation

```julia
julia> ]add WiSARD
```

or

```julia
julia> import Pkg

julia> Pkg.add("WiSARD")
```

### Example

```@example quick-start
using WiSARD

wnn = WNN{Symbol, UInt}(2, 2)

train!(wnn, [1 1 0 0], :x)
train!(wnn, [0 0 1 1], :y)

println(classify(wnn, [1 1 0 0]) == :x)
println(classify(wnn, [0 0 1 1]) == :y)
```

### Citing WiSARD.jl

```tex
@software{xavier:2022,
  author       = {Pedro Maciel Xavier},
  title        = {WiSARD.jl},
  month        = {10},
  year         = {2022},
  publisher    = {Zenodo},
  version      = {v0.3.1},
  doi          = {10.5281/zenodo.6407358},
  url          = {https://doi.org/10.5281/zenodo.6407358}
}
```
