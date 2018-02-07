"infinite vector with non-trivial values within a,b. Outside this range it simply repeats a default value"
struct RangeInfiniteVector{T} <: AbstractInfiniteVector{T}
    support::UnitRange{Int}
    default::T
    values::Vector{T}
    function RangeInfiniteVector{T}(support::UnitRange{Int}, default::T, values::Vector{T}) where {T}
        length(values) == length(support) || throw(ArgumentError("values and support must have the same length"))
        if support.start > support.stop
            support = 1:0  # standardize empty support
        end
        new(support, default, values)
    end
end
RangeInfiniteVector(support::UnitRange{Int}, default::T, values::Vector{T}) where {T} = RangeInfiniteVector{T}(support, default, values)
RangeInfiniteVector(support::UnitRange{Int}, default::T) where {T} = RangeInfiniteVector(support, default, fill(default, length(support)))
RangeInfiniteVector(a::Int, default::T, values::Vector{T}) where {T} = RangeInfiniteVector(a : a + length(values) - 1, default, values)
RangeInfiniteVector(a::Int, values::Vector{T}) where {T} = RangeInfiniteVector(a : a + length(values) - 1, zero(T), values)

EmptyRangeInfiniteVector(default::T) where {T} = RangeInfiniteVector(1:0, default)

"Resizes an infinite vector to a new support"
function resize(x::RangeInfiniteVector{T}, support::UnitRange{Int})::RangeInfiniteVector{T} where {T}
    RangeInfiniteVector{T}(support, x[support], x.default)
end


Base.getindex(x::RangeInfiniteVector{T}, i::Int) where {T} = i ∈ x.support ? x.values[i - x.support.start + 1] : x.default
Base.getindex(x::RangeInfiniteVector{T}, I) where {T} = [x[i] for i in I]

function Base.setindex!(x::RangeInfiniteVector{T}, v::T, i::Int) where {T}
    if i ∈ x.support
        x.values[i - x.support.start + 1] = v
    else
        throw(BoundsError())
    end
end

function Base.:+(x::RangeInfiniteVector, y::RangeInfiniteVector)
    a = min(x.support.start, y.support.start)
    b = max(x.support.stop, y.support.stop)
    values = [x[i] + y[i] for i = a:b]
    default = x.default + y.default
    return RangeInfiniteVector(a:b, default, values)
end

Base.:-(x::RangeInfiniteVector) = RangeInfiniteVector(x.support, -x.default, -x.values)
Base.:-(x::RangeInfiniteVector, y::RangeInfiniteVector) = x + (-y)

maximum(x::RangeInfiniteVector) = max(x.default, maximum(x.values))
minimum(x::RangeInfiniteVector) = min(x.default, minimum(x.values))
extrema(x::RangeInfiniteVector) = extrema([x.default; x.values])
