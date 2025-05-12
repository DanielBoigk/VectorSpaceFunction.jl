module RadialFunction
    import Base: +,*, inv, identity, ==, ≈
    export RadialFunction
    include("RadialPolynomials.jl")
    
    
    struct RadialFunction 
        rad_func:: RadialPolynomials.RadialPolynomial
        exp:: Int
    end



end