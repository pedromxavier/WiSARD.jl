# Examples

## MNIST
```@setup mnist
using Pkg
Pkg.develop(path=joinpath(@__DIR__, ".."))
```

```@example mnist
using DataFrames
using WiSARD

wnn = WNN{String, UInt}(28, 28)
```