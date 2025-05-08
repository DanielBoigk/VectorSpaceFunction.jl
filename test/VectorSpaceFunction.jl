using Test

# Define some simple test functions
f1(x) = x^2
f2(x) = sin(x)
f3(x) = cos(x)

@testset "VectorSpaceFunction Tests" begin
    # Test constructor and evaluation
    @testset "Constructor and Evaluation" begin
        vsf = VectorSpaceFunction([f1, f2], [2, 3])
        @test vsf(1.0) ≈ 2 * f1(1.0) + 3 * f2(1.0)
        @test vsf(0.0) ≈ 2 * f1(0.0) + 3 * f2(0.0)
    end

    # Test addition of two VectorSpaceFunctions
    @testset "Addition of VectorSpaceFunctions" begin
        vsf1 = VectorSpaceFunction([f1, f2], [1, 2])
        vsf2 = VectorSpaceFunction([f2, f3], [3, 4])
        result = vsf1 + vsf2
        @test length(result.functions) == 3
        @test result(1.0) ≈ f1(1.0) + 5 * f2(1.0) + 4 * f3(1.0)
    end

    # Test addition with a single function
    @testset "Addition with Function" begin
        vsf = VectorSpaceFunction([f1], [1])
        result = vsf + f1
        @test length(result.functions) == 1
        @test result.coefficients[1] == 2
        @test result(2.0) ≈ 2 * f1(2.0)
    end

    # Test scalar multiplication
    @testset "Scalar Multiplication" begin
        vsf = VectorSpaceFunction([f1, f2], [1, 2])
        result = 3 * vsf
        @test result.coefficients == [3, 6]
        @test result(1.0) ≈ 3 * f1(1.0) + 6 * f2(1.0)
        
        result2 = vsf * 2
        @test result2.coefficients == [2, 4]
        @test result2(1.0) ≈ 2 * f1(1.0) + 4 * f2(1.0)
    end

    # Test negation
    @testset "Negation" begin
        vsf = VectorSpaceFunction([f1, f2], [1, 2])
        neg_vsf = -vsf
        @test neg_vsf.coefficients == [-1, -2]
        @test neg_vsf(1.0) ≈ -(f1(1.0) + 2 * f2(1.0))
    end

    # Test subtraction
    @testset "Subtraction" begin
        vsf1 = VectorSpaceFunction([f1, f2], [1, 2])
        vsf2 = VectorSpaceFunction([f2, f3], [1, 1])
        result = vsf1 - vsf2
        @test result(1.0) ≈ f1(1.0) + f2(1.0) - f3(1.0)
    end

    # Test simplify
    @testset "Simplify" begin
        vsf = VectorSpaceFunction([f1, f1, f2], [1, 2, 3])
        simplified = simplify(vsf)
        @test length(simplified.functions) == 2
        @test simplified.coefficients[findfirst(x -> x == f1, simplified.functions)] == 3
        @test simplified.coefficients[findfirst(x -> x == f2, simplified.functions)] == 3
        @test simplified(1.0) ≈ 3 * f1(1.0) + 3 * f2(1.0)
    end

    # Test function scalar multiplication
    @testset "Function Scalar Multiplication" begin
        vsf = f1 * 2
        @test vsf.coefficients == [2]
        @test vsf.functions == [f1]
        @test vsf(1.0) ≈ 2 * f1(1.0)
        
        vsf2 = 3 * f2
        @test vsf2.coefficients == [3]
        @test vsf2.functions == [f2]
        @test vsf2(1.0) ≈ 3 * f2(1.0)
    end
end