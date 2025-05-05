module EvenPolynomial


import Base: +, -, *, length


struct EvenPolynomial 
    coeffs::Vector{Number}

    # Constructor to handle different ways of creating a polynomial
    EvenPolynomial(coeffs::Vector{<:Number}) = new(Vector{Number}(coeffs))
    EvenPolynomial(coeffs::Number...) = new(collect(Float64.(coeffs)))
end


function (p::EvenPolynomial)(x::Number)
    result = 0.0
    power = x*x
    # Execute Horner Scheme with power
    result += p.coeffs[1]
    for coeff in p.coeffs[2:end]
        result  *= power
        result += coeff
    end
    return result
end

function batch_eval(polys::Vector{EvenPolynomial{T}}, x::Vector{T}) where {T<:Number}
    nₓ = length(x)
    nₚ = length(polys)
    results = zeros(T, nₓ, nₚ) # Initialize with the correct type

    Threads.@threads for i in 1:nₓ
        xi_squared = x[i]^2
        for j in 1:nₚ
            poly = polys[j]
            val = zero(T) # Initialize with the correct type
            for k in eachindex(poly.coeffs)
                val += poly.coeffs[k] * (xi_squared)^(k - 1)
            end
            results[i, j] = val
        end
    end
    return results
end

function batch_eval2(polys::Vector{EvenPolynomial{T}}, x::Vector{T}) where {T<:Number}
    nₓ = length(x)
    nₚ = length(polys)
    results = zeros(T, nₓ, nₚ) # Initialize with the correct type

    grades = [length(p.coeffs) for p in polys]
    precomputed_powers = zeros(T, nₓ, maximum(grades))
    for i in 1:nₓ

        
    return results
end






end