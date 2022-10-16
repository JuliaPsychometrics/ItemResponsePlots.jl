"""
    item_characteristic_curve(model::ItemResponseModel, item, response)
    item_characteristic_curve(model::ItemResponseModel, item)

Create a plot of the item characteristic curve for `response` of `item`.

An item characteristic curve plots the probability for `response` of `item` given the
person ability θ.

If `response` is omitted, the default plot behaviour depends on `model`:
- For models where `response_type(model) == Dichotomous` the item characteristic curve for
  response = 1 is plotted.
- For models where `response_type(model) <: Union{Nominal, Ordinal}` all category characteristic
  curves are plotted.

# Plot attributes
## Generic
- `color`: The color of the item characteristic curve.
- `theta`: The values of `theta` for which to plot the item characteristic curve.
  default: $(getdefault("theta")).

## Specific
### Models with `SamplingEstimate`
- `samples`: The number of samples to plot. default: $(getdefault("samples"))

"""
MakieCore.@recipe(ItemCharacteristicCurve) do scene
    MakieCore.Attributes(
        # generic
        color=colorant"#10b981",
        theta=getdefault("theta"),
        # SamplingEstimate
        samples=getdefault("samples"),
    )
end

function MakieCore.plot!(icc::ItemCharacteristicCurve{<:Tuple{<:ItemResponseModel,Int,Int}})
    # parse arguments
    model = icc[1]
    response = icc[3]
    checkresponsetype(response_type(model[]), response[])

    rt = response_type(model[])
    pd = person_dimensionality(model[])
    id = item_dimensionality(model[])
    et = estimation_type(model[])

    icc = _item_characteristic_curve(rt, pd, id, et, icc, response[])

    # TODO: general settings

    return icc
end

function MakieCore.plot!(icc::ItemCharacteristicCurve{<:Tuple{<:ItemResponseModel,Int}})
    model = icc[1]

    rt = response_type(model[])
    pd = person_dimensionality(model[])
    id = item_dimensionality(model[])
    et = estimation_type(model[])

    if rt == Dichotomous
        icc = _item_characteristic_curve(rt, pd, id, et, icc, 1)
    end

    return icc
end

function _item_characteristic_curve(::Type{Dichotomous}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{SamplingEstimate}, icc, response)
    model = icc[1]
    item = icc[2]
    nsamples = size(model[].pars, 1)
    n = icc.samples[]
    iter = sample(1:nsamples, n, replace=false)

    probs = Matrix{Float64}(undef, length(icc.theta[]), n)

    for (i, theta) in enumerate(icc.theta[])
        probs[i, :] .= irf(model[], theta, item[], response)[iter]
    end

    for iter in eachcol(probs)
        lines!(icc, icc.theta[], iter, color=(icc.color, 50 / n))
    end

    return icc
end

function _item_characteristic_curve(::Type{Dichotomous}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{PointEstimate}, icc, response)
    model = icc[1]
    item = icc[2]
    probs = [irf(model[], theta, item[], response) for theta in icc.theta[]]
    lines!(icc, icc.theta[], probs, color=icc.color)
    return icc
end

const item_characteristic_curve = itemcharacteristiccurve
const item_characteristic_curve! = itemcharacteristiccurve!
