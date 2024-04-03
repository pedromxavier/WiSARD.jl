var documenterSearchIndex = {"docs":
[{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"ENV[\"DATADEPS_ALWAYS_ACCEPT\"] = true","category":"page"},{"location":"examples/#MNIST","page":"Examples","title":"MNIST","text":"","category":"section"},{"location":"examples/#Traning-and-Testing","page":"Examples","title":"Traning & Testing","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using WiSARD\nusing MLDatasets: MNIST\n\n# pixel activation threshold\nTHRESHOLD = 64 # 25% of 256\n\n# -*- Train data -*- #\ntrainset = MNIST(Int, :train)\n\nn = length(trainset)\nx = [trainset[i][:features] .> THRESHOLD for i = 1:n]\ny = [trainset[i][:targets] for i = 1:n]\n\n# -*- Test data -*- #\ntestset = MNIST(Int, :test)\n\nn̂ = length(testset)\nx̂ = [testset[i][:features] .> THRESHOLD for i = 1:n̂]\nŷ = [testset[i][:targets] for i = 1:n̂]\n\nwnn = WNN{Int, UInt}(28, 28; seed=0)\n\nWiSARD.classhint!(wnn, collect(0:9))\n\ntrain!.(wnn, x, y)\n\nȳ = classify.(wnn, x̂)\nα = WiSARD.accuracy(ŷ, ȳ)\n\nprintln(\"Accuracy: $(100α)%\")","category":"page"},{"location":"examples/#Mental-Images","page":"Examples","title":"Mental Images","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using Images\n\nimg = WiSARD.images(RGB, wnn; w=28, h=28)\n\nimg[0]","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"img[1]","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"img[2]","category":"page"},{"location":"examples/#Fashion-MNIST","page":"Examples","title":"Fashion MNIST","text":"","category":"section"},{"location":"examples/#Traning-and-Testing-2","page":"Examples","title":"Traning & Testing","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using WiSARD\nusing MLDatasets: FashionMNIST\n\n# pixel activation threshold\nTHRESHOLD = 64 # 25% of 256\n\n# -*- Train data -*- #\ntrainset = FashionMNIST(Int, :train)\n\nn = length(trainset)\nx = [trainset[i][:features] .> THRESHOLD for i = 1:n]\ny = [trainset[i][:targets] for i = 1:n]\n\n# -*- Test data -*- #\ntestset = FashionMNIST(Int, :test)\n\nn̂ = length(testset)\nx̂ = [testset[i][:features] .> THRESHOLD for i = 1:n̂]\nŷ = [testset[i][:targets] for i = 1:n̂]\n\nwnn = WNN{Int, UInt}(28, 28; seed=0)\n\ntrain!.(wnn, x, y)\n\nȳ = classify.(wnn, x̂)\nα = WiSARD.accuracy(ŷ, ȳ)\n\nprintln(\"Accuracy: $(100α)%\")","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"using Images\n\nimg = WiSARD.images(RGB, wnn; w=28, h=28)\n\nimg[0]","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"img[1]","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"img[2]","category":"page"},{"location":"manual/#Manual","page":"Manual","title":"Manual","text":"","category":"section"},{"location":"manual/#WiSARD","page":"Manual","title":"WiSARD","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"The WiSARD (Wilkie, Stoneham and Aleksander Recognition Device) Weightless Neural Network Model is conceptually composed by an associative array of discriminators or classes. To each one is assigned a key of arbitrary type, usually some string.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"Inside every discriminator lies an array with n virtual \"RAM\" units who act pretty much like real RAM memories. To every RAM unit are given d addressing bits.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"info: Info\nIn a first moment, the input dimension must match the model's dimension n times d. Also, choices made for n and d do impact the recognition performance.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"During initialization, a random mapping between the network's input and the RAM addresses is defined and kept static during the whole model's lifetime.","category":"page"},{"location":"manual/#Training","page":"Manual","title":"Training","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"For training, some binary pattern is written to the correspondig discriminator by incrementing the values store at the RAM addresses where the predefined mapping points to. Values from randomly gathered spots within the original input vector are grouped to form each address whose values are initially set to zero by using a sparse data structure.","category":"page"},{"location":"manual/#Classification","page":"Manual","title":"Classification","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Here, the process is pretty much similar. The input is used to address the same RAM positions on every discriminator, this time reading the stored value and assigning a corresponding response rate. The greatest score indicates the chosen class.","category":"page"},{"location":"manual/#Interface","page":"Manual","title":"Interface","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.jl's interface is very simple. A model is created by calling the WNN{S, T}(n::Int, d::Int; seed::Int) constructor, where n is the number of RAM units and d is the respective number of addressing bits. The optional parameter seed is used to induce a random mapping between the input and each RAM's bus.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.WNN","category":"page"},{"location":"manual/#WiSARD.WNN","page":"Manual","title":"WiSARD.WNN","text":"WNN{S, T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {S <: Any, T <: Union{Unsigned, BigInt}}\nWNN{T}(d::Int, n::Int; seed::Union{Int, Nothing}=nothing) where {T <: Union{Unsigned, BigInt}}\n\nReferences:\n\n[1] Carvalho, Danilo & Carneiro, Hugo & França, Felipe & Lima, Priscila. (2013). B-bleaching : Agile Overtraining Avoidance in the WiSARD Weightless Neural Classifier. \n\n\n\n\n\n","category":"type"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.train!\nWiSARD.classhint!","category":"page"},{"location":"manual/#WiSARD.train!","page":"Manual","title":"WiSARD.train!","text":"\n\n\n\n","category":"function"},{"location":"manual/#WiSARD.classhint!","page":"Manual","title":"WiSARD.classhint!","text":"\n\n\n\n","category":"function"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.classify\nWiSARD.accuracy","category":"page"},{"location":"manual/#WiSARD.classify","page":"Manual","title":"WiSARD.classify","text":"\n\n\n\n","category":"function"},{"location":"manual/#WiSARD.accuracy","page":"Manual","title":"WiSARD.accuracy","text":"accuracy(ŷ, y)\n\n\n\n\n\n","category":"function"},{"location":"manual/#Encoding","page":"Manual","title":"Encoding","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"<script>\nfunction updateKaTeXContent(element, content) {\n  window.katex.render(content, element, {throwOnError: true});\n}\n\nfunction latex_vector(t) {\n    let n = t.length;\n    let c = \"c\".repeat(n);\n    let T = t.join(\" & \");\n    \n    return `\\\\left[\\\\begin{array}{${c}} ${T} \\\\end{array}\\\\right]`\n}\n</script>","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.encode!\nWiSARD.encode","category":"page"},{"location":"manual/#WiSARD.encode!","page":"Manual","title":"WiSARD.encode!","text":"encode!\n\nIn-place version of encode.\n\n\n\n\n\n","category":"function"},{"location":"manual/#WiSARD.encode","page":"Manual","title":"WiSARD.encode","text":"encode\n\n\n\n\n\n","category":"function"},{"location":"manual/#OneHot","page":"Manual","title":"OneHot","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"The mathrmOH^k  left0 1right to mathbbB^k encoding function activates the output vector entries, one at a time.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"<script>\nfunction one_hot(x, n) {\n    if (n == 1) return [1];\n\n    let t = new Array(n);\n\n    t[0] = (x < 1 / n) ? 1 : 0;\n\n    for (let i = 1; i < n - 1; i++) {\n        t[i] = (i / n <= x && x < ((i + 1) / n)) ? 1 : 0;\n    }\n\n    t[n - 1] = ((n - 1) / n <= x) ? 1 : 0;\n\n    return t;\n}\n\nfunction updateOneHot(x) {\n    let n = 10;\n    let X = x.toFixed(2);   \n    let t = one_hot(x, n);\n    let v = latex_vector(t);\n\n    let content = `\\\\mathrm{OH}^{${n}}(${X}) = ${v}`;\n    let element = document.getElementById(\"onehot\");\n\n    updateKaTeXContent(element, content);\n}\n</script>\n<p>\n  <span>$x = $</span>\n  <input\n    id      = \"onehot-slider\"\n    style   = \"display: inline-block; vertical-align: sub;\"\n    type    = \"range\"\n    value   = \"0.50\"\n    min     = \"0.00\"\n    max     = \"1.00\"\n    step    = \"0.01\"\n    oninput = \"updateOneHot(parseFloat(this.value));\"\n  >\n  <span>$\\implies$</span>\n  <output id = \"onehot\"></output>\n</p>","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.OneHot","category":"page"},{"location":"manual/#WiSARD.OneHot","page":"Manual","title":"WiSARD.OneHot","text":"OneHot()\n\n\n\n\n\n","category":"type"},{"location":"manual/#Thermometer","page":"Manual","title":"Thermometer","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Let mathrmT^k  left0 1right to mathbbB^k.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"<script>\nfunction thermometer(x, n) {\n    let t = new Array(n);\n\n    for (let i = 0; i < n; i++) {\n        t[i] = ((i + 1) / (n + 1) <= x) ? 1 : 0;\n    }\n\n    return t;\n}\n\nfunction updateThermometer(x) {\n    let n = 10;\n    let X = x.toFixed(2);\n    let t = thermometer(x, n);\n    let v = latex_vector(t);\n\n    let content = `\\\\mathrm{T}^{${n}}(${X}) = ${v}`\n    let element = document.getElementById(\"thermometer\");\n\n    updateKaTeXContent(element, content);\n}\n</script>\n<p>\n  <span>$x = $</span>\n  <input\n    id      = \"thermometer-slider\"\n    style   = \"display: inline-block; vertical-align: sub;\"\n    type    = \"range\"\n    value   = \"0.50\"\n    min     = \"0.00\"\n    max     = \"1.00\"\n    step    = \"0.01\"\n    oninput = \"updateThermometer(parseFloat(this.value));\"\n  >\n  <span>$\\implies$</span>\n  <output id=\"thermometer\"></output>\n</p>","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.Thermometer","category":"page"},{"location":"manual/#WiSARD.Thermometer","page":"Manual","title":"WiSARD.Thermometer","text":"Thermometer()\n\n\n\n\n\n","category":"type"},{"location":"manual/#Gaussian-Thermometer","page":"Manual","title":"Gaussian Thermometer","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"Let mathrmGT^k_musigma  mathbbR to mathbbB^k.","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"<script>\nfunction gaussian_thermometer(x, n, mu = 0.0, sigma = 1.0) {\n    y = (x - mu) / (Math.sqrt(2) * sigma);\n    z = 0.5 * (1 + window.mathjs.erf(y));\n\n    return thermometer(z, n);\n}\n\nfunction updateGaussianThermometer(x) {\n    let n = 10;\n    let X = x.toFixed(2);\n    let t = gaussian_thermometer(x, n);\n    let v = latex_vector(t);\n    let s = x < 0 ? \"\" : \"+\"\n\n    let content = `\\\\mathrm{T}^{${n}}(${s}${X}) = ${v}`;\n    let element = document.getElementById(\"gaussian-thermometer\");\n\n    updateKaTeXContent(element, content);\n}\n</script>\n<p>\n  <span>$x = $</span>\n  <input\n    id      = \"gaussian-thermometer-slider\"\n    style   = \"display: inline-block; vertical-align: sub;\"\n    type    = \"range\"\n    value   = \"0.00\"\n    min     = \"-1.00\"\n    max     = \"1.00\"\n    step    = \"0.01\"\n    oninput = \"updateGaussianThermometer(parseFloat(this.value));\"\n  >\n  <span>$\\implies$</span>\n  <output id = \"gaussian-thermometer\"></output>\n</p>","category":"page"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.GaussianThermometer","category":"page"},{"location":"manual/#WiSARD.GaussianThermometer","page":"Manual","title":"WiSARD.GaussianThermometer","text":"GaussianThermometer{S}(μ::S, σ::S) where {S}\n\n\n\n\n\n","category":"type"},{"location":"manual/#Circular","page":"Manual","title":"Circular","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.Circular","category":"page"},{"location":"manual/#WiSARD.Circular","page":"Manual","title":"WiSARD.Circular","text":"Circular{S}() where {S}\n\n\n\n\n\n","category":"type"},{"location":"manual/#Extra","page":"Manual","title":"Extra","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.address","category":"page"},{"location":"manual/#WiSARD.address","page":"Manual","title":"WiSARD.address","text":"\n\n\n\n","category":"function"},{"location":"manual/#Mental-Images","page":"Manual","title":"Mental Images","text":"","category":"section"},{"location":"manual/","page":"Manual","title":"Manual","text":"WiSARD.deaddress\nWiSARD.images","category":"page"},{"location":"manual/#WiSARD.deaddress","page":"Manual","title":"WiSARD.deaddress","text":"\n\n\n\n","category":"function"},{"location":"manual/#WiSARD.images","page":"Manual","title":"WiSARD.images","text":"\n\n\n\n","category":"function"},{"location":"#WiSARD.jl-Documentation","page":"Home","title":"WiSARD.jl Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package implements the WiSARD (Wilkie, Stoneham and Aleksander Recognition Device) Weightless Neural Network Model, a lightning-fast classifier over binary data.","category":"page"},{"location":"#Quick-Start","page":"Home","title":"Quick Start","text":"","category":"section"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> ]add WiSARD","category":"page"},{"location":"","page":"Home","title":"Home","text":"or","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> import Pkg\n\njulia> Pkg.add(\"WiSARD\")","category":"page"},{"location":"#Example","page":"Home","title":"Example","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using WiSARD\n\nwnn = WNN{Symbol, UInt}(2, 2)\n\ntrain!(wnn, [1 1 0 0], :x)\ntrain!(wnn, [0 0 1 1], :y)\n\nprintln(classify(wnn, [1 1 0 0]) == :x)\nprintln(classify(wnn, [0 0 1 1]) == :y)","category":"page"},{"location":"#Citing-WiSARD.jl","page":"Home","title":"Citing WiSARD.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"@software{xavier:2022,\n  author       = {Pedro Maciel Xavier},\n  title        = {WiSARD.jl},\n  month        = {10},\n  year         = {2022},\n  publisher    = {Zenodo},\n  version      = {v0.3.1},\n  doi          = {10.5281/zenodo.6407358},\n  url          = {https://doi.org/10.5281/zenodo.6407358}\n}","category":"page"}]
}