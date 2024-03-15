@doc raw"""

"""
abstract type AbstractWNN{S,T} <: MLJMI.Probabilistic end

mutable struct WNN{S,T} <: AbstractWNN{S,T}
    m::Int
    n::Int
    β::Union{Int,Nothing}
end

# keyword constructor
function WNN(; m::Integer=32, n::Integer=32, β::Integer=3)
	model = WNN(m, n, β)

	message = MMI.clean!(model)
    
	isempty(message) || @warn message

	return model
end

function MLJMI.clean!(model::WNN)
	message = ""

	if model.lambda < 0
		message = "Need lambda ≥ 0. Resetting lambda=0. "

		model.lambda = 0
	end
	
    return message
end