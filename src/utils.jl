ci(level) = (level / 2, 1 - level / 2)

modeltraits(m::ItemResponseModel) = (response_type(m), person_dimensionality(m), item_dimensionality(m), estimation_type(m))
