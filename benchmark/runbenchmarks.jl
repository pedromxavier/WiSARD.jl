import Pkg
Pkg.add(path=joinpath(@__DIR__, ".."))
Pkg.instantiate()

using WiSARD
using PkgBenchmark

const RESULTS_PATH = joinpath(@__DIR__, "results")
const RESULTS_FILE = joinpath(RESULTS_PATH, "results.json")

function main()
    results = benchmarkpkg(WiSARD)

    writeresults(RESULTS_FILE, results)

    return nothing
end

main() # Here we go!