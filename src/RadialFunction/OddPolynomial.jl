struct OddPolynomial{T<:Number} <: AbstractPolynomial{T}
    coeffs::Vector{T}  # coeffs[i] is coefficient of x^(2i - 1)
    function OddPolynomial(coeffs::Vector{T}) where {T<:Number}
        isempty(coeffs) && throw(ArgumentError("Coefficient vector cannot be empty"))
        new{T}(coeffs)
    end
end

OddPolynomial(coeffs::T...) where {T<:Number} = OddPolynomial(collect(coeffs))

length(p::OddPolynomial) = length(p.coeffs)
order(p::OddPolynomial) = 2*length(p) + 1


# Evaluation (Horner-like for x^{2i - 1})
function (p::OddPolynomial{T})(x::S) where {T<:Number, S<:Number}
    x2 = x * x
    result = zero(promote_type(T, S))
    for coeff in reverse(p.coeffs)
        result = result * x2 + coeff
    end
    return x * result
end



function batch_eval(polys::Vector{OddPolynomial{T1}}, x::Vector{T2}) where {T1<:Number, T2<:Number}
    T = promote_type(T1, T2)
    nₓ = length(x)
    nₚ = length(polys)
    results = zeros(T, nₓ, nₚ)

    if nₓ == 0 || nₚ == 0
        return results
    end

    grades = [length(p.coeffs) for p in polys]
    max_grade = maximum(grades; init=0)

    # Precompute x and x^2, x^4, ..., x^{2(max_grade-1)}
    precomputed_powers = zeros(T, nₓ, max_grade)
    for i in 1:nₓ
        if max_grade > 0
            precomputed_powers[i, 1] = one(T)  # x^0 for internal Horner use
            if max_grade > 1
                x2 = T(x[i])^2
                precomputed_powers[i, 2] = x2  # x^2
                for k in 3:max_grade
                    precomputed_powers[i, k] = precomputed_powers[i, k-1] * x2  # x^{2(k-1)}
                end
            end
        end
    end

    Threads.@threads for i in 1:nₓ
        xi = T(x[i])
        for j in 1:nₚ
            poly = polys[j]
            val = zero(T)
            for k in reverse(eachindex(poly.coeffs))
                val = val * precomputed_powers[i, 2] + T(poly.coeffs[k])
            end
            results[i, j] = xi * val
        end
    end

    return results
end


function *(p::OddPolynomial{T}, a::S}) where {T<:Number, S<:Number}
    return OddPolynomial(p.coeffs .* a)
end
function *(a::S, p::OddPolynomial{T}) where {T<:Number, S<:Number}
    return OddPolynomial(p.coeffs .* a)
end

function *(p::OddPolynomial{T}, q::OddPolynomial{S}) where {T<:Number, S<:Number}
    # Compute the product of two odd polynomials
    n = length(p.coeffs)
    m = length(q.coeffs)
    result_coeffs = zeros(promote_type(T,S), n + m )
    for i in 1:n
        for j in 1:m
            result_coeffs[i + j ] += p.coeffs[i] * q.coeffs[j]
        end
    end
    return EvenPolynomial(result_coeffs)
end

# EvenPolynomial * OddPolynomial → OddPolynomial
function *(p::EvenPolynomial{T}, q::OddPolynomial{S}) where {T<:Number, S<:Number}
    n = length(p.coeffs)
    m = length(q.coeffs)
    result_coeffs = zeros(promote_type(T, S), n + m - 1)
    for i in 1:n
        for j in 1:m
            result_coeffs[i + j - 1] += p.coeffs[i] * q.coeffs[j]
        end
    end
    return OddPolynomial(result_coeffs)
end

# OddPolynomial * EvenPolynomial → OddPolynomial (commutative)
*(p::OddPolynomial, q::EvenPolynomial) = q * p
