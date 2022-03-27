# Examples

## MNIST
```@setup mnist
using Pkg
Pkg.develop(path=joinpath(@__DIT__, ".."))
```

```@example mnist
using DataFrames
using WiSARD

wnn = WNN{String, UInt}(28, 28)
```