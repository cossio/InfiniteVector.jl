"infinite vector with non-trivial values in discrete indexes. For other indexes has a default value."
struct DiscreteInfiniteVector{T} <: AbstractInfiniteVector{T}
    values::Dict{Int, T}
    default::T
    DiscreteInfiniteVector{T}(values::Dict{Int, T}, default::T) where {T} = new(values, default)
end
DiscreteInfiniteVector(values::Dict{Int, T}, default::T) where {T} = DiscreteInfiniteVector{T}(values, default)
DiscreteInfiniteVector(values::Dict{Int, T}) where {T <: Number} = DiscreteInfiniteVector(values, zero(T))
DiscreteInfiniteVector(default::T) where {T} = DiscreteInfiniteVector(Dict{Int, T}(), default)

Base.getindex(x::DiscreteInfiniteVector, i::Int) = get(x.values, i, x.default)
Base.getindex(x::DiscreteInfiniteVector, I) = [x[i] for i in I]
Base.setindex!(x::DiscreteInfiniteVector, v, i) = x.values[i] = v
