using WiSARD
using DataFrames
import CSV

train_df = CSV.read(joinpath(@__DIR__, "mnist_train.csv"), DataFrame)
test_df = CSV.read(joinpath(@__DIR__, "mnist_test.csv"), DataFrame)