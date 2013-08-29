This is just a tiny playground to compare basic forward-mode autodiff in Python and Julia. The Julia code is SO much nicer, and with simple rules it handles a lot more, like matrix multiplication.

# Python #

```python
In [1]: from forward_mode import *

In [2]: DualNumber(1)
Out[2]: 1

In [3]: DualNumber(1,2)
Out[3]: 1 + 2 e

In [4]: DualNumber(1,2) + 5
Out[4]: 6 + 2 e

In [5]: DualNumber(1,2) * DualNumber(1,2)
Out[5]: 1 + 4 e

In [6]: f = lambda x: 3*x**2+2*x+7

In [7]: f(DualNumber(5,1))
Out[7]: 92 + 32 e

In [8]: Df = D(f)

In [9]: Df(5) # derivative of f evaluated at 5
Out[9]: array([ 32.])

In [10]: Df = lambda x: 6*x+2 # derivative of f, by hand

In [11]: Df(5)
Out[11]: 32 # it worked!
```

# Julia #

```julia
julia> require("forward_mode.jl")

julia> DualNumber(1)
DualNumber(1.0,0.0)

julia> DualNumber(1,2)
DualNumber(1.0,2.0)

julia> DualNumber(1,2) + 5
DualNumber(6.0,2.0)

julia> DualNumber(1,2) * DualNumber(1,2)
DualNumber(1.0,4.0)

julia> D(sin)(0)
1.0

julia> f(x) = 3*x^2 + 2*x + 7
# methods for generic function f
f(x) at none:1

julia> f(DualNumber(5,1))
DualNumber(92.0,32.0)

julia> D(x -> 3*x^2+2*x+7)(5) # derivative evaluated at 5
32.0

julia> A = randn(3,3)
3x3 Array{Float64,2}:
  0.235806   0.801981  -0.204849
 -0.69821   -0.463073   0.667738
  0.001391  -0.337116  -0.600577

julia> B = randn(3,3)
3x3 Array{Float64,2}:
  0.773917    0.785002  -0.25077
 -0.0327547   0.930431  -0.742221
  1.43265    -1.87466   -1.8494

julia> f(x) = A*x
# methods for generic function f
f(x) at none:1

julia> g(x) = B*x
# methods for generic function g
g(x) at none:1

julia> D(x -> f(g(x)))([1;2;3]) # matrix derviatives FOR FREE
3x3 Array{Float64,2}:
 -0.13725    1.31532   -0.275534
  0.431443  -2.23073   -0.716118
 -0.848296   0.813303   1.36057

julia> A*B
3x3 Array{Float64,2}:
 -0.13725    1.31532   -0.275534
  0.431443  -2.23073   -0.716118
 -0.848296   0.813303   1.36057
```
