module WiSARD

using Random
using SpecialFunctions

include("interface.jl")
include("model/model.jl")
include("encoding/encoding.jl")
include("images/images.jl")
include("analysis/analysis.jl")

end # module
