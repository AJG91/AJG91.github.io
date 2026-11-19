window.MathJax = window.MathJax || {};
window.MathJax.tex = window.MathJax.tex || {};

window.MathJax.tex.macros = {
  ...(window.MathJax.tex.macros || {}),

  // Number systems
  R: "\\mathbb{R}",
  C: "\\mathbb{C}",
  N: "\\mathbb{N}",
  Z: "\\mathbb{Z}",

  // Vector quantities
  F: "\\mathbf{F}",
  E: "\\mathbf{E}",
  B: "\\mathbf{B}",
  vvec: "\\mathbf{v}",
  xvec: "\\mathbf{x}",

  // Derivatives
  deriv: ["\\frac{\\mathrm{d} #1}{\\mathrm{d} #2}", 2],
  dderiv: ["\\frac{\\mathrm{d}^2 #1}{\\mathrm{d} #2^2}", 2],

  // Tensor notation
  kdelta: ["\\delta_{#1#2}", 2],
  levi: ["\\varepsilon_{#1#2#3}", 3],

  // Mathematical operators
  cross: "\\times",
  abs: ["\\left|#1\\right|", 1]
};