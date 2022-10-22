function mnist_benchmark!(SUITE::BenchmarkGroup)
    mnist_wnn = () -> WiSARD.WNN{Int,UInt}(28, 28)

    SUITE["mnist"] = BenchmarkGroup(["MNIST"])

    mnist_trainset = MLDatasets.MNIST(Int, :train)
    mnist_train_x  = [mnist_trainset[i][:features] for i = 1:60_000]
    mnist_train_y  = [mnist_trainset[i][:targets] for i = 1:60_000]

    SUITE["mnist"]["train"] = @benchmarkable WiSARD.train!.(
        $mnist_wnn(),
        $mnist_train_x,
        $mnist_train_y,
    )

    mnist_testset = MLDatasets.MNIST(Int, :test)
    mnist_test_x  = [mnist_testset[i][:features] for i = 1:10_000]
    # mnist_test_y  = [mnist_testset[i][:targets] for i = 1:10_000]

    SUITE["mnist"]["test"] = @benchmarkable WiSARD.classify.(
        $mnist_wnn(),
        $mnist_test_x,
    )

    return nothing
end