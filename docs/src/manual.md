# Manual

## WiSARD

The WiSARD (*Wilkie, Stoneham and Aleksander Recognition Device*) Weightless Neural Network Model is conceptually composed by an associative array of *discriminators* or classes. To each one is assigned a key of arbitrary type, usually some string.

Inside every discriminator lies an array with ``n`` virtual "RAM" units who act pretty much like real RAM memories. To every RAM unit are given ``d`` addressing bits.

!!! info
    In a first moment, the input dimension must match the model's dimension ``n \times d``. Also, choices made for ``n`` and ``d`` do impact the recognition performance.

During initialization, a random mapping between the network's input and the RAM addresses is defined and kept static during the whole model's lifetime.

### Training

For training, some binary pattern is written to the correspondig discriminator by incrementing the values store at the RAM addresses where the predefined mapping points to. Values from randomly gathered spots within the original input vector are grouped to form each address whose values are initially set to zero by using a sparse data structure.

### Classification

Here, the process is pretty much similar. The input is used to address the same RAM positions on every discriminator, this time reading the stored value and assigning a corresponding response rate. The greatest score indicates the chosen class.

## Interface

`WiSARD.jl`'s interface is very simple. A model is created by calling the `WNN{S, T}(n::Int, d::Int; seed::Int)` constructor, where `n` is the number of RAM units and `d` is the respective number of addressing bits. The optional parameter `seed` is used to induce a random mapping between the input and each RAM's bus.

```@docs
WiSARD.WNN
```

```@docs
WiSARD.train!
WiSARD.classhint!
```

```@docs
WiSARD.classify
WiSARD.accuracy
```

## Encoding

```@raw html
<script>
function updateKaTeXContent(element, content) {
  window.katex.render(content, element, {throwOnError: true});
}

function latex_vector(t) {
    let n = t.length;
    let c = "c".repeat(n);
    let T = t.join(" & ");
    
    return `\\left[\\begin{array}{${c}} ${T} \\end{array}\\right]`
}
</script>
```

```@docs
WiSARD.encode!
WiSARD.encode
```

### OneHot

The ``\mathrm{OH}^{k} : \left[{0, 1}\right] \to \mathbb{B}^{k}`` encoding function activates the output vector entries, one at a time.

```@raw html
<script>
function one_hot(x, n) {
    if (n == 1) return [1];

    let t = new Array(n);

    t[0] = (x < 1 / n) ? 1 : 0;

    for (let i = 1; i < n - 1; i++) {
        t[i] = (i / n <= x && x < ((i + 1) / n)) ? 1 : 0;
    }

    t[n - 1] = ((n - 1) / n <= x) ? 1 : 0;

    return t;
}

function updateOneHot(x) {
    let n = 10;
    let X = x.toFixed(2);   
    let t = one_hot(x, n);
    let v = latex_vector(t);

    let content = `\\mathrm{OH}^{${n}}(${X}) = ${v}`;
    let element = document.getElementById("onehot");

    updateKaTeXContent(element, content);
}
</script>
<p>
  <span>$x = $</span>
  <input
    id      = "onehot-slider"
    style   = "display: inline-block; vertical-align: sub;"
    type    = "range"
    value   = "0.50"
    min     = "0.00"
    max     = "1.00"
    step    = "0.01"
    oninput = "updateOneHot(parseFloat(this.value));"
  >
  <span>$\implies$</span>
  <output id = "onehot"></output>
</p>
```

```@docs
WiSARD.OneHot
```

### Thermometer

Let ``\mathrm{T}^{k} : \left[{0, 1}\right] \to \mathbb{B}^{k}``.

```@raw html
<script>
function thermometer(x, n) {
    let t = new Array(n);

    for (let i = 0; i < n; i++) {
        t[i] = ((i + 1) / (n + 1) <= x) ? 1 : 0;
    }

    return t;
}

function updateThermometer(x) {
    let n = 10;
    let X = x.toFixed(2);
    let t = thermometer(x, n);
    let v = latex_vector(t);

    let content = `\\mathrm{T}^{${n}}(${X}) = ${v}`
    let element = document.getElementById("thermometer");

    updateKaTeXContent(element, content);
}
</script>
<p>
  <span>$x = $</span>
  <input
    id      = "thermometer-slider"
    style   = "display: inline-block; vertical-align: sub;"
    type    = "range"
    value   = "0.50"
    min     = "0.00"
    max     = "1.00"
    step    = "0.01"
    oninput = "updateThermometer(parseFloat(this.value));"
  >
  <span>$\implies$</span>
  <output id="thermometer"></output>
</p>
```

```@docs
WiSARD.Thermometer
```

### Gaussian Thermometer

Let ``\mathrm{GT}^{k}_{\mu,\sigma} : \mathbb{R} \to \mathbb{B}^{k}``.

```@raw html
<script>
function gaussian_thermometer(x, n, mu = 0.0, sigma = 1.0) {
    y = (x - mu) / (Math.sqrt(2) * sigma);
    z = 0.5 * (1 + window.mathjs.erf(y));

    return thermometer(z, n);
}

function updateGaussianThermometer(x) {
    let n = 10;
    let X = x.toFixed(2);
    let t = gaussian_thermometer(x, n);
    let v = latex_vector(t);
    let s = x < 0 ? "" : "+"

    let content = `\\mathrm{T}^{${n}}(${s}${X}) = ${v}`;
    let element = document.getElementById("gaussian-thermometer");

    updateKaTeXContent(element, content);
}
</script>
<p>
  <span>$x = $</span>
  <input
    id      = "gaussian-thermometer-slider"
    style   = "display: inline-block; vertical-align: sub;"
    type    = "range"
    value   = "0.00"
    min     = "-1.00"
    max     = "1.00"
    step    = "0.01"
    oninput = "updateGaussianThermometer(parseFloat(this.value));"
  >
  <span>$\implies$</span>
  <output id = "gaussian-thermometer"></output>
</p>
```

```@docs
WiSARD.GaussianThermometer
```

### Circular
```@docs
WiSARD.Circular
```

## Extra
```@docs
WiSARD.address
```

### Mental Images
```@docs
WiSARD.deaddress
WiSARD.images
```