
import Base: +,*, inv, identity, ==, ≈
export VectorSpaceFunction


struct VectorSpaceFunction <: Function
    functions::Vector{Function}
    coefficients::Vector{Number}
    VectorSpaceFunction(functions::Vector{Function}, coefficients::Vector{Number}) = new(functions, coefficients)
end

function (vsf::VectorSpaceFunction)(x)
    sum(vsf.functions[i](x) * vsf.coefficients[i] for i in 1:length(vsf.functions))
end

function +(vsf1::VectorSpaceFunction, vsf2::VectorSpaceFunction)
    #check if there are any common functions in vsf1 and vsf2
    #if there are, add their coefficients
    #if there are not, just concatenate the functions and coefficients
    #return a new VectorSpaceFunction
    #find common functions
    common_functions = intersect(vsf1.functions, vsf2.functions)
    #find indices of common functions in vsf1 and vsf2
    indices1 = [findfirst(x -> x == f, vsf1.functions) for f in common_functions]
    indices2 = [findfirst(x -> x == f, vsf2.functions) for f in common_functions]
    #add coefficients of common functions
    new_coefficients = vsf1.coefficients
    for i in 1:length(common_functions)
        new_coefficients[indices1[i]] += vsf2.coefficients[indices2[i]]
    end
    #concatenate functions and coefficients
    new_functions = [vsf1.functions; vsf2.functions[setdiff(1:end, indices2)]]
    new_coefficients = [new_coefficients; vsf2.coefficients[setdiff(1:end, indices2)]]
    VectorSpaceFunction(new_functions, new_coefficients)
end
function +(f::Function, vsf::VectorSpaceFunction)
    if f in vsf.functions
        i = findfirst(x -> x == f, vsf.functions)
        vsf.coefficients[i] += 1
        return vsf
    end
    VectorSpaceFunction([f; vsf.functions], [1; vsf.coefficients])
end
function *(a::Number, f::Function)
    VectorSpaceFunction([f], [a])
end
function *(f::Function, a::Number)
    VectorSpaceFunction([f], [a])
end
function +(vsf::VectorSpaceFunction, f::Function)
    f + vsf
end

function *(vsf::VectorSpaceFunction, c::Number)
    VectorSpaceFunction(vsf.functions, vsf.coefficients .* c)
end
function *(c::Number, vsf::VectorSpaceFunction)
    VectorSpaceFunction(vsf.functions, vsf.coefficients .* c)
end

function -(vsf::VectorSpaceFunction)
    VectorSpaceFunction(vsf.functions, -vsf.coefficients)
end
function -(vsf1::VectorSpaceFunction, vsf2::VectorSpaceFunction)
        vsf1 + (-vsf2)
end
function -(f::Function, vsf::VectorSpaceFunction)
    f + (-vsf)    
end
function -(vsf::VectorSpaceFunction, f::Function)
    vsf + (-f)
end

function simplify(vsf::VectorSpaceFunction)
    unique_functions = unique(vsf.functions)
    new_coefficients = zeros(length(unique_functions))
    for i in 1:length(unique_functions)
        for j in 1:length(vsf.functions)
            if vsf.functions[j] == unique_functions[i]
                new_coefficients[i] += vsf.coefficients[j]
            end
        end
    end
    VectorSpaceFunction(unique_functions, new_coefficients)
end
