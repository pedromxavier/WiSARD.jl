requirejs.config({
    paths: {
        'katex' : 'https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.13.24/katex.min',
        'mathjs': 'https://cdn.jsdelivr.net/npm/mathjs@11.6.0/lib/browser/math.min',
    },
});

require(['katex', 'mathjs'], function (katex, mathjs) {
    window.katex  = katex;
    window.mathjs = mathjs;
});

window.onload = function () {
    updateOneHot(0.5);
    updateThermometer(0.5);
    updateGaussianThermometer(0.0);
}