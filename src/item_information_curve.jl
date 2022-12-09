"""
    item_information_curve(model::ItemResponseModel, item, response)
    item_information_curve(model::ItemResponseModel, item)

Create a plot of the item information curve for `response` of `item`.

If `response` is omitted, the default plot behaviour depends on `model`:
- For models where `response_type(model) == Dichotomous` the item information curve for
  response = 1 is plotted.
- For models where `response_type(model) <: Union{Nominal, Ordinal}` all category information
  curves are plotted.

# Plot attributes
## Generic
- `color`: The color of the item information curve.
- `theta`: The values of `theta` for which to plot the item information curve.
  default: $(getdefault("theta")).

## Specific
### Models with `SamplingEstimate`
- `samples`: The number of samples to plot. default: $(getdefault("samples")).

"""
@recipe(ItemInformationCurve) do scene
    Attributes(
        # generic
        color=colorant"#10b981",
        theta=getdefault("theta"),
        # SamplingEstimate
        samples=getdefault("samples"),
    )
end

function plot!(iic::ItemInformationCurve{<:Tuple{<:ItemResponseModel,Int,Int}})
    # parse arguments
    model = iic[1]
    response = iic[3]
    checkresponsetype(response_type(model[]), response[])

    rt = response_type(model[])
    pd = person_dimensionality(model[])
    id = item_dimensionality(model[])
    et = estimation_type(model[])

    iic = _item_information_curve(rt, pd, id, et, iic)
    return iic
end

function _item_information_curve(::Type{Dichotomous}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{SamplingEstimate}, iic)
    model = iic[1]
    item = iic[2]
    response = iic[3]
    nsamples = size(model[].pars, 1)
    n = iic.samples[]
    iter = sample(1:nsamples, n, replace=false)

    probs = Matrix{Float64}(undef, length(iic.theta[]), n)

    for (i, theta) in enumerate(iic.theta[])
        probs[i, :] .= iif(model[], theta, item[], response[])[iter]
    end

    for iter in eachcol(probs)
        lines!(iic, iic.theta[], iter, color=(iic.color, 50 / n))
    end

    return iic
end

function _item_information_curve(::Type{Dichotomous}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{PointEstimate}, iic)
    model = iic[1]
    item = iic[2]
    response = iic[3]
    probs = [iif(model[], theta, item[], response[]) for theta in iic.theta[]]
    lines!(iic, iic.theta[], probs, color=iic.color)
    return iic
end

const item_information_curve = iteminformationcurve
const item_information_curve! = iteminformationcurve!
