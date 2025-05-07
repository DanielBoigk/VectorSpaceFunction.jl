@testset "EvenPolynomial batch_eval Tests" begin
    # Test 1: Single polynomial, single input
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

@testset "EvenPolynomial batch_eval Tests" begin
    # Test 4: Multiple polynomials, multiple inputs
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

@testset "single_coefficient" begin
    # Test 5: Polynomial with single coefficient
    p1 = EvenPolynomial([5.0]) # Constant polynomial: 5
    x = [1.0, 2.0, 3.0]
    result = batch_eval([p1], x)
    @test size(result) == (3, 1)
    @test all(isapprox.(result, 5.0, atol=1e-10))
end

@testset "empty_input" begin
    # Test 6: Empty input vector
    p1 = EvenPolynomial([1.0, 2.0])
    x = Float64[]
    result = batch_eval([p1], x)
    @test size(result) == (0, 1)
end

@testset "empty_polynomial_list" begin
    # Test 7: Empty polynomial list
    x = [1.0, 2.0]
    result = batch_eval(EvenPolynomial{Float64}[], x)
    @test size(result) == (2, 0)
end

@testset "type_consistency" begin
    # Test 8: Type consistency with different number types
    p1 = EvenPolynomial([1, 2]) # Integer coefficients
    x = Float32[1.0, 2.0]
    result = batch_eval([p1], x)
    @test eltype(result) == Float32
    @test isapprox(result[1, 1], 1.0 + 2.0 * (1.0^2), atol=1e-6)
    @test isapprox(result[2, 1], 1.0 + 2.0 * (2.0^2), atol=1e-6)
end