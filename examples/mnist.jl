using WiSARD
using DataFrames
import CSV

# First, retrive MNIST .csv data from
# https://www.kaggle.com/oddrationale/mnist-in-csv

train_df = CSV.read(joinpath(@__DIR__, "mnist_train.csv"), DataFrame)
test_df = CSV.read(joinpath(@__DIR__, "mnist_test.csv"), DataFrame)