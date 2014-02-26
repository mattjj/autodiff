importall Base

type DualNumber{T<:Real} <: Number
    real::T
    eps::T
end

DualNumber(x::Real,y::Real) = DualNumber(promote(x,y)...)
DualNumber(x::Real) = DualNumber(promote(x,0)...)

convert{T}(::Type{DualNumber{T}},x::Real) = DualNumber(convert(T,x),zero(T))

promote_rule{S}(::Type{Bool}, ::Type{DualNumber{S}}) = DualNumber{S}
promote_rule{T<:Real,S}(::Type{T}, ::Type{DualNumber{S}}) = DualNumber{promote_type(T,S)}
promote_rule{T,S}(::Type{DualNumber{T}}, ::Type{DualNumber{S}}) = DualNumber{promote_type(T,S)}

function show(io::IO, x::DualNumber)
    pm(x) = x < 0 ? " - $(-x)" : " + $x"
    print(io, x.real, pm(x.eps), "e")
end

eps(x::Union(DualNumber,AbstractArray{DualNumber})) = map(x -> x.eps, x)

+(x::DualNumber,y::DualNumber) = DualNumber(x.real + y.real,x.eps + y.eps)
-(x::DualNumber,y::DualNumber) = DualNumber(x.real - y.real,x.eps - y.eps)
*(x::DualNumber,y::DualNumber) = DualNumber(x.real * y.real,x.eps*y.real+x.real*y.eps)
/(x::DualNumber,y::DualNumber) = DualNumber(x.real/y.real,(x.eps*y.real - x.real*y.eps)/y.real^2)

sin(x::DualNumber) = DualNumber(sin(x.real),cos(x.real)*x.eps)
cos(x::DualNumber) = DualNumber(cos(x.real),-sin(x.real)*x.eps)
exp(x::DualNumber) = DualNumber(exp(x.real),exp(x.real)*x.eps)

function grad(f::Function)
    function gradf{T <: Real}(pt::T)
        eps(f(DualNumber(pt,1)))
    end
    function gradf{T <: Real}(pt::AbstractArray{T})
        hcat([eps(f([DualNumber(x,i==j) for (j,x)=enumerate(pt)])) for i=1:length(pt)]...)
    end
end

