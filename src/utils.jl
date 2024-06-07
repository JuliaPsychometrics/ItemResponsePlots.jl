function ci(level)
    lower = level / 2
    upper = 1 - level / 2
    return lower, upper
end

function modeltraits(m::ItemResponseModel)
    return (
        response_type(m),
        person_dimensionality(m),
        item_dimensionality(m),
        estimation_type(m),
    )
end

function modeltraits(M::Type{<:ItemResponseModel})
    return (response_type(M), Univariate, Univariate, PointEstimate)
end
