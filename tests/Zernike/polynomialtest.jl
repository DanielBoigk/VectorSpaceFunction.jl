@testset "Test 1: Single polynomial, single input" begin
    p1 = EvenPolynomial([1.0, 2.0]) # Represents 1 + 2x^2
    x = [2.0]
    result = batch_eval([p1], x)
    @test size(result) == (1, 1)
    @test isapprox(result[1, 1], 1.0 + 2.0 * (2.0^2), atol=1e-10)
end

@testset "Test 2: Single polynomial, multiple inputs" begin
    p1 = EvenPolynomial([1.0, 2.0, 3.0]) # Represents 1 + 2x^2 + 3x^4
    x = [1.0, 2.0, 3.0]
    result = batch_eval([p1], x)
    @test size(result) == (3, 1)
    @test isapprox(result[1, 1], 1.0 + 2.0 * (1.0^2) + 3.0 * (1.0^4), atol=1e-10)
    @test isapprox(result[2, 1], 1.0 + 2.0 * (2.0^2) + 3.0 * (2.0^4), atol=1e-10)
    @test isapprox(result[3, 1], 1.0 + 2.0 * (3.0^2) + 3.0 * (3.0^4), atol=1e-10)
end

@testset "Test 3: Multiple polynomials, single input" begin
    p1 = EvenPolynomial([1.0, 2.0]) # 1 + 2x^2
    p2 = EvenPolynomial([0.0, 1.0, 1.0]) # 0 + x^2 + x^4
    x = [2.0]
    result = batch_eval([p1, p2], x)
    @test size(result) == (1, 2)
    @test isapprox(result[1, 1], 1.0 + 2.0 * (2.0^2), atol=1e-10)
    @test isapprox(result[1, 2], 0.0 + 1.0 * (2.0^2) + 1.0 * (2.0^4), atol=1e-10)
end 

@testset "Test 4: Multiple polynomials, multiple inputs" begin
    p1 = EvenPolynomial([1.0, 2.0]) # 1 + 2x^2
    p2 = EvenPolynomial([0.0, 1.0, 1.0]) # 0 + x^2 + x^4
    x = [1.0, 2.0]
    result = batch_eval([p1, p2], x)
    @test size(result) == (2, 2)
    @test isapprox(result[1, 1], 1.0 + 2.0 * (1.0^2), atol=1e-10)
    @test isapprox(result[1, 2], 0.0 + 1.0 * (1.0^2) + 1.0 * (1.0^4), atol=1e-10)
    @test isapprox(result[2, 1], 1.0 + 2.0 * (2.0^2), atol=1e-10)
    @test isapprox(result[2, 2], 0.0 + 1.0 * (2.0^2) + 1.0 * (2.0^4), atol=1e-10)
end

@testset "Test 5: Polynomial with single coefficient" begin
    p1 = EvenPolynomial([5.0]) # Constant polynomial: 5
    x = [1.0, 2.0, 3.0]
    result = batch_eval([p1], x)
    @test size(result) == (3, 1)
    @test all(isapprox.(result, 5.0, atol=1e-10))
end

@testset "Test 6: Empty input vector" begin
    p1 = EvenPolynomial([1.0, 2.0])
    x = Float64[]
    result = batch_eval([p1], x)
    @test size(result) == (0, 1)
end

@testset "Test 7: Empty polynomial list" begin
    x = [1.0, 2.0]
    result = batch_eval(EvenPolynomial{Float64}[], x)
    @test size(result) == (2, 0)
end

@testset "Test 8: Type consistency with different number types" begin
    # 
    p1 = EvenPolynomial([1, 2]) # Integer coefficients
    x = Float32[1.0, 2.0]
    result = batch_eval([p1], x)
    @test eltype(result) == Float32
    @test isapprox(result[1, 1], 1.0 + 2.0 * (1.0^2), atol=1e-6)
    @test isapprox(result[2, 1], 1.0 + 2.0 * (2.0^2), atol=1e-6)
end


#
@testset "Multiplication" begin
    p1 = EvenPolynomial([1.0, 2.0])
    p2 = EvenPolynomial([3, 4])
    p3 = p1 * p2
    @test p3.coeffs == [3.0, 10.0, 8.0]
end

@testset "batch_eval for OddPolynomial" begin
    # Define a few OddPolynomials
    p1 = OddPolynomial(1.0)                       # f(x) = x
    p2 = OddPolynomial(0.0, 1.0)                  # f(x) = x^3
    p3 = OddPolynomial(1.0, 2.0, 3.0)             # f(x) = x + 2x^3 + 3x^5
    p4 = OddPolynomial(1.0, -1.0, 0.0, 4.0)       # f(x) = x - x^3 + 0x^5 + 4x^7

    # Input values
    xvals = [-2.0, -1.0, 0.0, 1.0, 2.0]

    # Run batch_eval
    polys = [p1, p2, p3, p4]
    result = batch_eval(polys, xvals)

    # Manually evaluate expected values
    expected = [p(x) for x in xvals, p in polys]

    # Compare results
    @test size(result) == size(expected)
    @test isapprox(result, expected; rtol=1e-10)
end

@testset "OddPolynomial Multiplication" begin
    # Create two odd polynomials
    p = OddPolynomial(1.0, 2.0)      # p(x) = x + 2x^3
    q = OddPolynomial(3.0, -1.0)     # q(x) = 3x - x^3
    
    # Multiply them
    r = p * q  # Should be EvenPolynomial
    #println(r.coeffs)
    @test r isa EvenPolynomial
    
    # Test that p(x) * q(x) ≈ r(x) for various x
    for x in [-2.0, -1.0, 0.0, 1.0, 2.0]
        @test isapprox(p(x) * q(x), r(x); atol=1e-10)
    end
    end