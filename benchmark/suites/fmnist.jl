function fmnist_benchmark!(SUITE::BenchmarkGroup)
    fmnist_wnn = () -> WiSARD.WNN{Int,UInt}(28, 28)

    SUITE["fmnist"] = BenchmarkGroup(["fmnist"])

    fmnist_trainset = MLDatasets.fmnist(Int, :train)
    fmnist_train_x  = [fmnist_trainset[i][:features] for i = 1:60_000]
    fmnist_train_y  = [fmnist_trainset[i][:targets] for i = 1:60_000]

    SUITE["fmnist"]["train"] = @benchmarkable WiSARD.train!.(
        $fmnist_wnn(),
        $fmnist_train_x,
        $fmnist_train_y,
    )

    fmnist_testset = MLDatasets.fmnist(Int, :test)
    fmnist_test_x  = [fmnist_testset[i][:features] for i = 1:10_000]
    # fmnist_test_y  = [fmnist_testset[i][:targets] for i = 1:10_000]

    SUITE["fmnist"]["test"] = @benchmarkable WiSARD.classify.(
        $fmnist_wnn(),
        $fmnist_test_x,
    )

    return nothing
end