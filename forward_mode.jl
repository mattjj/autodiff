importall Base

type DualNumber <: Number
    real::Float64
    eps::Float64
    DualNumber(x::Real) = new(convert(Float64,x),0.)
    DualNumber(x::Real,y::Real) = new(convert(Float64,x),convert(Float64,y))
end

eps(x::Union(DualNumber,AbstractArray{DualNumber})) = map(x -> x.eps, x)

+(x::DualNumber,y::DualNumber) = DualNumber(x.real + y.real,x.eps + y.eps)
-(x::DualNumber,y::DualNumber) = DualNumber(x.real - y.real,x.eps - y.eps)
*(x::DualNumber,y::DualNumber) = DualNumber(x.real * y.real,x.eps*y.real+x.real*y.eps)
/(x::DualNumber,y::DualNumber) = DualNumber(x.real/y.real,(x.eps*y.real - x.real*y.eps)/y.real^2)

sin(x::DualNumber) = DualNumber(sin(x.real),cos(x.real)*x.eps)
cos(x::DualNumber) = DualNumber(cos(x.real),-sin(x.real)*x.eps)
exp(x::DualNumber) = DualNumber(exp(x.real),exp(x.real)*x.eps)

convert(::Type{DualNumber},x::Real) = DualNumber(x)
promote_rule{T <: Real}(::Type{DualNumber},::Type{T}) = DualNumber

function D(f::Function)
    function Df{T <: Real}(pt::T)
        eps(f(DualNumber(pt,1)))
    end
    function Df{T <: Real}(pt::AbstractArray{T})
        hcat([eps(f([DualNumber(x,i==j) for (j,x)=enumerate(pt)])) for i=1:length(pt)]...)
    end
end

