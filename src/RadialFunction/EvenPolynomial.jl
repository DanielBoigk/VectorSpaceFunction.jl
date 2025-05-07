struct EvenPolynomial{T<:Number}
    coeffs::Vector{T}
    function EvenPolynomial(coeffs::Vector{T}) where {T<:Number}
        isempty(coeffs) && throw(ArgumentError("Coefficient vector cannot be empty"))
        return new{T}(coeffs)
    end
end

EvenPolynomial(coeffs::T...) where {T<:Number} = EvenPolynomial(collect(coeffs))

function (p::EvenPolynomial{T})(x::S) where {T<:Number, S<:Number}
    x2 = x * x
    result = zero(promote_type(T, S))
    for coeff in reverse(p.coeffs)
        result = result * x2 + coeff
    end
    return result
end

function batch_eval(polys::Vector{EvenPolynomial{T1}}, x::Vector{T2}) where {T1<:Number, T2<:Number}
    T = promote_type(T1, T2)
    nₓ = length(x)
    nₚ = length(polys)
    results = zeros(T, nₓ, nₚ)

    if nₓ == 0 || nₚ == 0
        return results
    end

    grades = [length(p.coeffs) for p in polys]
    max_grade = maximum(grades; init=0)

    precomputed_powers = zeros(T, nₓ, max_grade)
    for i in 1:nₓ
        if max_grade > 0
            precomputed_powers[i, 1] = one(T)  # x^0
            if max_grade > 1
                precomputed_powers[i, 2] = T(x[i])^2  # x^2
                for k in 3:max_grade
                    precomputed_powers[i, k] = precomputed_powers[i, k-1] * precomputed_powers[i, 2]
                end
            end
        end
    end

    Threads.@threads for i in 1:nₓ
        for j in 1:nₚ
            poly = polys[j]
            val = zero(T)
            for k in eachindex(poly.coeffs)
                val += T(poly.coeffs[k]) * precomputed_powers[i, k]
            end
            results[i, j] = val
        end
    end

    return results
end
