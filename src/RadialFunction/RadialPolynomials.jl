
import Base: +, -, *, length

abstract type AbstractPolynomial{T<:Number} end

Base.zero(::Type{OddPolynomial{T}}) where {T<:Number} = OddPolynomial(T(0))
Base.zero(::Type{EvenPolynomial{T}}) where {T<:Number} = EvenPolynomial(T(0))

Base.zero(p::OddPolynomial{T}) where {T<:Number} = zero(OddPolynomial{T})
Base.zero(p::EvenPolynomial{T}) where {T<:Number} = zero(EvenPolynomial{T})


include("EvenPolynomial.jl")
include("OddPolynomial.jl")

export EvenPolynomial, OddPolynomial


using Polynomials

function Base.convert(::Type{Polynomial{T}}, p::EvenPolynomial{T}) where T
    coeffs = Vector{T}(undef, 2length(p.coeffs))
    coeffs .= 0
    for (i, c) in enumerate(p.coeffs)
        coeffs[2i - 1] = c  # x^(2(i-1)) = x^(2i-2)
    end
    return Polynomial(coeffs)
end

function Base.convert(::Type{Polynomial{T}}, p::OddPolynomial{T}) where T
    coeffs = Vector{T}(undef, 2length(p.coeffs))
    coeffs .= 0
    for (i, c) in enumerate(p.coeffs)
        coeffs[2i] = c  # x^(2i - 1)
    end
    return Polynomial(coeffs)
end

function *(p::AbstractPolynomial{T}, q::AbstractPolynomial{T}) where T
    poly_p = convert(Polynomial{T}, p)
    poly_q = convert(Polynomial{T}, q)
    return poly_p * poly_q  # result is general Polynomial
end

function try_restructure(poly::Polynomial)
    coeffs = poly.coeffs
    if all(i % 2 == 0 for (i, c) in enumerate(coeffs) if c ≠ 0)
        return EvenPolynomial(coeffs[1:2:end])
    elseif all(i % 2 == 1 for (i, c) in enumerate(coeffs) if c ≠ 0)
        return OddPolynomial(coeffs[2:2:end])
    else
        return poly
    end
end

import Base: +, -

# Even ± Odd → general Polynomial
function +(p::EvenPolynomial{T}, q::OddPolynomial{S}) where {T<:Number, S<:Number}
    P = promote_type(T, S)
    Polynomial(convert(Polynomial{P}, p).coeffs + convert(Polynomial{P}, q).coeffs)
end

function +(p::OddPolynomial{T}, q::EvenPolynomial{S}) where {T<:Number, S<:Number}
    q + p  # commutative
end

function -(p::EvenPolynomial{T}, q::OddPolynomial{S}) where {T<:Number, S<:Number}
    P = promote_type(T, S)
    Polynomial(convert(Polynomial{P}, p).coeffs - convert(Polynomial{P}, q).coeffs)
end

function -(p::OddPolynomial{T}, q::EvenPolynomial{S}) where {T<:Number, S<:Number}
    P = promote_type(T, S)
    Polynomial(convert(Polynomial{P}, p).coeffs - convert(Polynomial{P}, q).coeffs)
end

function +(p::AbstractPolynomial{T}, q::AbstractPolynomial{S}) where {T<:Number, S<:Number}
    P = promote_type(T, S)
    Polynomial(convert(Polynomial{P}, p).coeffs + convert(Polynomial{P}, q).coeffs)
end

function -(p::AbstractPolynomial{T}, q::AbstractPolynomial{S}) where {T<:Number, S<:Number}
    P = promote_type(T, S)
    Polynomial(convert(Polynomial{P}, p).coeffs - convert(Polynomial{P}, q).coeffs)
end
