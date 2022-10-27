var documenterSearchIndex = {"docs":
[{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"ENV[\"DATADEPS_ALWAYS_ACCEPT\"] = true","category":"page"},{"location":"examples/#MNIST","page":"Examples","title":"MNIST","text":"","category":"section"},{"location":"examples/#Traning-and-Testing","page":"Examples","title":"Traning & Testing","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using WiSARD\nusing MLDatasets\n\nwnn = WNN{Int, UInt}(28, 28; seed=0)\n\ntrain_x, train_y = MNIST.traindata(\n    Float64;\n    dir=joinpath(@__DIR__, \"data\", \"mnist\")\n)\n\ntrain_x = Array{Bool}[train_x[:, :, i] .>= 0.25 for i = 1:60_000]\n\ntest_x, test_y = MNIST.testdata(\n    Float64;\n    dir=joinpath(@__DIR__, \"data\", \"mnist\")\n)\n\ntest_x = Array{Bool}[test_x[:, :, i] .>= 0.25 for i = 1:10_000]\n\ntrain!(wnn, train_y, train_x)\n\ns = count(classify(wnn, test_x; bleach=10) .== test_y)\n\nprintln(\"Accuracy: $(100. * s / 10_000)%\")","category":"page"},{"location":"examples/#Mental-Images","page":"Examples","title":"Mental Images","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using Images\n\nimages = WiSARD.images(RGB, wnn; w=28, h=28)\n\nimages[0]","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"images[1]","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"images[2]","category":"page"},{"location":"examples/#Fashion-MNIST","page":"Examples","title":"Fashion MNIST","text":"","category":"section"},{"location":"examples/#Traning-and-Testing-2","page":"Examples","title":"Traning & Testing","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using WiSARD\nusing MLDatasets\n\nwnn = WNN{Int, UInt}(28, 28; seed=0)\n\ntrain_x, train_y = FashionMNIST.traindata(\n    Float64;\n    dir=joinpath(@__DIR__, \"data\", \"fashion-mnist\")\n)\n\ntrain_x = Array{Bool}[train_x[:, :, i] .>= 0.25 for i = 1:60_000]\n\ntest_x, test_y = FashionMNIST.testdata(\n    Float64;\n    dir=joinpath(@__DIR__, \"data\", \"fashion-mnist\")\n)\n\ntest_x = Array{Bool}[test_x[:, :, i] .>= 0.25 for i = 1:10_000]\n\ntrain!(wnn, train_y, train_x)\n\ns = count(classify(wnn, test_x; bleach=10) .== test_y)\n\nprintln(\"Accuracy: $(100. * s / 10_000)%\")","category":"page"},{"location":"examples/#Mental-Images-2","page":"Examples","title":"Mental Images","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using Images\n\nimages = WiSARD.images(RGB, wnn; w=28, h=28)\n\nimages[0]","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"images[1]","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"images[2]","category":"page"},{"location":"manual/#Manual","page":"Manual","title":"Manual","text":"","category":"section"},{"location":"manual/#WiSARD","page":"Manual","title":"WiSARD","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"The WiSARD (Wilkie, Stoneham and Aleksander Recognition Device) Weightless Neural Network Model is conceptually composed by an associative array of discriminators or classes. To each one is assigned a key of arbitrary type, usually some string.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Inside every discriminator lies an array with n virtual \"RAM\" units who act pretty much like real RAM memories. To every RAM unit are given d addressing bits.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"info: Info\nIn a first moment, the input dimension must match the model's dimension n times d. Also, choices made for n and d do impact the recognition performance.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"During initialization, a random mapping between the network's input and the RAM addresses is defined and kept static during the whole model's lifetime.","category":"page"},{"location":"manual/#Training","page":"Manual","title":"Training","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"For training, some binary pattern is written to the correspondig discriminator by incrementing the values store at the RAM addresses where the predefined mapping points to. Values from randomly gathered spots within the original input vector are grouped to form each address whose values are initially set to zero by using a sparse data structure.","category":"page"},{"location":"manual/#Classification","page":"Manual","title":"Classification","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Here, the process is pretty much similar. The input is used to address the same RAM positions on every discriminator, this time reading the stored value and assigning a corresponding response rate. The greatest score indicates the chosen class.","category":"page"},{"location":"manual/#Interface","page":"Manual","title":"Interface","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.jl's interface is very simple. A model is created by calling the WNN{S, T}(n::Int, d::Int; seed::Int) constructor, where n is the number of RAM units and d is the respective number of addressing bits. The optional parameter seed is used to induce a random mapping between the input and each RAM's bus.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"The model is trained and used for classification via the train! and classify functions.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.WNN\nWiSARD.train!\nWiSARD.classify","category":"page"},{"location":"manual/#WiSARD.WNN","page":"Manual","title":"WiSARD.WNN","text":"WNN{S, T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {S <: Any, T <: Union{Unsigned, BigInt}}\nWNN{T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {T <: Union{Unsigned, BigInt}}\n\nReferences:\n\n[1] Carvalho, Danilo & Carneiro, Hugo & França, Felipe & Lima, Priscila. (2013). B-bleaching : Agile Overtraining Avoidance in the WiSARD Weightless Neural Classifier. \n\n\n\n\n\n","category":"type"},{"location":"manual/#WiSARD.train!","page":"Manual","title":"WiSARD.train!","text":"\n\n\n\n","category":"function"},{"location":"manual/#WiSARD.classify","page":"Manual","title":"WiSARD.classify","text":"\n\n\n\n","category":"function"},{"location":"manual/#Encoding","page":"Manual","title":"Encoding","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.onehot\nWiSARD.thermometer","category":"page"},{"location":"manual/#WiSARD.onehot","page":"Manual","title":"WiSARD.onehot","text":"onehot(x::Float64, n::Int)\nonehot(x::Vector{Float64}, n::Int)\n\n\n\n\n\n","category":"function"},{"location":"manual/#WiSARD.thermometer","page":"Manual","title":"WiSARD.thermometer","text":"thermometer(x::Float64, n::Int)\nthermometer(x::Vector{Float64}, n::Int)\n\n\n\n\n\n","category":"function"},{"location":"#WiSARD.jl-Documentation","page":"Home","title":"WiSARD.jl Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package implements the WiSARD (Wilkie, Stoneham and Aleksander Recognition Device) Weightless Neural Network Model, a lightning-fast classifier over binary data.","category":"page"},{"location":"#Quick-Start","page":"Home","title":"Quick Start","text":"","category":"section"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"pkg> add WiSARD","category":"page"},{"location":"","page":"Home","title":"Home","text":"or","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> import Pkg\n\njulia> Pkg.add(\"WiSARD\")","category":"page"},{"location":"#Example","page":"Home","title":"Example","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using WiSARD\n\nwnn = WNN{Symbol, UInt}(2, 2)\n\ntrain!(wnn, :x, [1 1 0 0])\ntrain!(wnn, :y, [0 0 1 1])\n\nclassify(wnn, [1 1 0 0]) == :x","category":"page"},{"location":"#Citing-WiSARD.jl","page":"Home","title":"Citing WiSARD.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"@software{xavier:2022,\n  author       = {Pedro Maciel Xavier},\n  title        = {WiSARD.jl},\n  month        = {apr},\n  year         = {2022},\n  publisher    = {Zenodo},\n  version      = {v0.2.0},\n  doi          = {10.5281/zenodo.6407358},\n  url          = {https://doi.org/10.5281/zenodo.6407358}\n}","category":"page"}]
}
