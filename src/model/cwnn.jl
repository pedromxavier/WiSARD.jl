struct Cluster{T}
    discs::Dict{Int,WNNCLS{T}}
end

struct CWNN{S,T} <: AbstractWNN{S,T}
    clusters::Dict{String,Cluster{T}}
end