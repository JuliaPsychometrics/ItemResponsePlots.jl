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
    return Attributes(;
        default_theme(scene)...,
        # generic
        color = theme(scene, :linecolor),
        palette = theme(scene, :palette),
        uncertainty_color = colorant"#bdbdbd",
        cycle = [:color],
        theta = getdefault("theta"),
        # SamplingEstimate
        samples = getdefault("samples"),
        uncertainty_type = getdefault("uncertainty_type"),
        quantiles = getdefault("quantiles"),
        aggregate_fun = getdefault("aggregate_fun"),
    )
end

function Makie.plot!(
    iic::ItemInformationCurve{<:Tuple{<:ItemResponseModel,<:Integer,<:Real}},
)
    # parse arguments
    model = iic[1]
    response = iic[3]
    rt, pd, id, et = modeltraits(model[])

    checkresponsetype(response_type(model[]), response[])

    info = iic_information(et, iic, response[])
    plot_iic_uncertainty!(et, iic, info)
    plot_iic_aggregate!(et, iic, info)

    return iic
end

function Makie.plot!(iic::ItemInformationCurve{<:Tuple{<:ItemResponseModel,<:Integer}})
    model = iic[1]
    rt, pd, id, et = modeltraits(model[])

    if rt <: Dichotomous
        info = iic_information(et, iic, 1)
        plot_iic_uncertainty!(et, iic, info)
        plot_iic_aggregate!(et, iic, info)
    elseif rt <: Union{Nominal,Ordinal}
        responses = 1:4
        for (i, response) in enumerate(responses)
            color = iic.palette.color[][i]
            info = iic_information(et, iic, response)
            plot_iic_uncertainty!(et, iic, info)
            plot_iic_aggregate!(et, iic, info, color)
        end
    else
        error("Not implemented for ResponseType $rt")
    end

    return iic
end

function iic_information(::Type{SamplingEstimate}, iic, response)
    model = iic[1]
    item = iic[2]
    nsamples = size(model[].pars, 1)
    n = ifelse(iic.uncertainty_type == :samples, iic.samples[], nsamples)
    iter = sample(1:nsamples, n, replace = false)

    info = Matrix{Float64}(undef, length(iic.theta[]), n)

    for (i, theta) in enumerate(iic.theta[])
        info[i, :] .= iif(model[], theta, item[], response)[iter]
    end

    return info
end

function iic_information(::Type{PointEstimate}, iic, response)
    model = iic[1]
    item = iic[2]
    info = [iif(model[], theta, item[], response) for theta in iic.theta[]]
    return info
end

function plot_iic_uncertainty!(::Type{SamplingEstimate}, iic, info)
    if iic.uncertainty_type[] == :samples
        for iter in eachcol(info)
            lines!(iic, iic.theta[], iter, color = iic.uncertainty_color[])
        end
    elseif iic.uncertainty_type[] == :interval
        q = [quantile(col, iic.quantiles[]) for col in eachrow(info)]
        lower = first.(q)
        upper = last.(q)
        band!(iic, iic.theta[], lower, upper, color = iic.uncertainty_color[])
    end

    return nothing
end

function plot_iic_uncertainty!(::Type{PointEstimate}, iic, response)
    return nothing
end

function plot_iic_aggregate!(::Type{SamplingEstimate}, iic, info, color = iic.color[])
    if !isnothing(iic.aggregate_fun[])
        agg = iic.aggregate_fun[](info)
        lines!(iic, iic.theta[], agg, cycle = iic.cycle[], color = color)
    end
    return nothing
end

function plot_iic_aggregate!(::Type{PointEstimate}, iic, info, color = iic.color[])
    lines!(iic, iic.theta[], info; cycle = iic.cycle[], color = color)
    return nothing
end

const item_information_curve = iteminformationcurve
const item_information_curve! = iteminformationcurve!
