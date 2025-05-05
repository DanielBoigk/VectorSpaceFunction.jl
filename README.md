# VectorSpaceFunction.jl

This package implements basic arithmetic operations + and * for arbitrary functions and numbers.
Note: There is no check whether the function actually has the right input and domain. There is also no check whether the underlying scalar type is commutative.

The goal with this package is too have basic function types like piece wise functions, polynomials, rational functions as well as trigonometric and radial function types that can be used like elements of a vector space and where given a specified domain a scalar product can be calculated have linear and non linear operators applied to them.


Routines that simplify the function into a computationally efficient version are also planned.

The ultimate goal is to have a library of optics that can combine into one uniform machine learning framework. 


| Method        | Differentiable | Scalar Product     | Localized | Good in High Dim | Ready | Online Approx | Fully constructed Optics | P-D-Optimization |
| ------------- | -------------- | ------------------ | --------- | ---------------- | ----- | ------------- | ------------------------ | ---------------- |
| Polynomials   | ✅              | ✅ (orthogonal)     | ❌         | ⚠️               |       |               |                          |                  |
| Rational      | ✅              | ⚠️                 | ❌         | ✅                |       |               |                          |                  |
| RBFs          | ✅              | ✅                  | ✅         | ✅                |       |               |                          |                  |
| Splines       | ✅              | ✅                  | ✅         | ⚠️               |       |               |                          |                  |
| Fourier       | ✅              | ✅ (FFT)            | ❌         | ✅                |       |               |                          |                  |
| Wavelets      | ✅              | ✅                  | ✅         | ⚠️               |       |               |                          |                  |
| Orth. Polys   | ✅              | ✅                  | ⚠️        | ⚠️               |       |               |                          |                  |
| Kernels       | ✅              | ✅ (kernel-defined) | ⚠️        | ✅                |       |               |                          |                  |
| Neural Nets   | ✅              | ⚠️ (numerical)     | ✅         | ✅                |       |               |                          |                  |
| Tensor Bases  | ✅              | ✅                  | ❌         | ⚠️               |       |               |                          |                  |
| Hardy/Bergman | ✅              | ✅                  | ❌         | ⚠️               |       |               |                          |                  |

