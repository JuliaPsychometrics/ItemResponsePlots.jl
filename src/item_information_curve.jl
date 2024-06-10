@recipe(ItemInformationCurve) do scene
    return Attributes(;
        default_theme(scene)...,
        # generic
        color = theme(scene, :linecolor),
        palette = theme(scene, :palette),
        uncertainty_color = colorant"#d4d4d4",
        cycle = [:color],
        theta = getdefault("theta"),
        # SamplingEstimate
        samples = getdefault("samples"),
        uncertainty_type = getdefault("uncertainty_type"),
        quantiles = getdefault("quantiles"),
        aggregate_fun = getdefault("aggregate_fun"),
    )
end

function Makie.plot!(iic::ItemInformationCurve{<:Tuple{<:Any,<:Any,<:Real}})
    # parse arguments
    model = iic[1]
    response = iic[3]
    rt, pd, id, et = modeltraits(model[])

    checkresponsetype(response_type(model[]), response[])

    info = iic_information(et, iic, response[])
    plot_iic_uncertainty!(et, iic, info)
    plot_iic_aggregate!(et, iic, info, label = "response = $(response[])")

    return iic
end

function Makie.plot!(iic::ItemInformationCurve{<:Tuple{<:Any,<:Any}})
    model = iic[1]
    rt, pd, id, et = modeltraits(model[])

    if rt <: Dichotomous
        info = iic_information(et, iic)
        plot_iic_uncertainty!(et, iic, info)
        plot_iic_aggregate!(et, iic, info)
    elseif rt <: Union{Nominal,Ordinal}
        # TODO: find a way for a robust way to fetch number of categories
        has_responses = true
        i = 0

        while has_responses
            i += 1
            color = iic.palette.color[][i]

            try
                info = iic_information(et, iic, i)
                plot_iic_uncertainty!(et, iic, info)
                plot_iic_aggregate!(et, iic, info; color, label = "response = $i")
            catch e
                if e isa BoundsError
                    has_responses = false
                    break
                else
                    rethrow(e)
                end
            end
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

function iic_information(::Type{PointEstimate}, iic)
    model = iic[1]
    item = iic[2]
    info = [information(model[], theta, item[]) for theta in iic.theta[]]
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

function plot_iic_aggregate!(::Type{SamplingEstimate}, iic, info; kwargs...)
    if !isnothing(iic.aggregate_fun[])
        f = iic.aggregate_fun[]
        agg = map(f, eachrow(info))
        lines!(iic, iic.theta[], agg; cycle = iic.cycle[], kwargs...)
    end
    return nothing
end

function plot_iic_aggregate!(::Type{PointEstimate}, iic, info; kwargs...)
    lines!(iic, iic.theta[], info; cycle = iic.cycle[], kwargs...)
    return nothing
end

# this is required to make plot labels work
# https://github.com/MakieOrg/Makie.jl/issues/1148
function Makie.get_plots(iic::ItemInformationCurve)
    return iic.plots
end

"""
    item_information_curve(model, item, response)
    item_information_curve(model, item)

Create a plot of the item information curve for `response` of `item`.

If `response` is omitted, the default plot behaviour depends on `model`:
- For models where `response_type(model) == Dichotomous` the total item information curve is
  plotted.
- For models where `response_type(model) <: Union{Nominal, Ordinal}` all category information
  curves are plotted.

# Plot attributes
## Generic
- `color`: The color of the item information curve.
- `uncertainty_color`: The color of the displayed uncertainty information.
  For plots with uncertainty intervals this is the color of the confidence band.
  For plots with sample based uncertainty information this is the line color of the samples.
- `theta`: The values of `theta` for which to plot the item information curve.
  default: $(getdefault("theta")).

## Specific
### Models with `SamplingEstimate`
- `samples`: The number of samples to plot. default: `$(getdefault("samples"))`
- `uncertainty_type`: Changes how the uncertainty of the estimate is displayed.
  If `uncertainty_type = :samples`, then iterations from the MCMC estimation are plotted.
  If `unvertainty_type = :interval`, then uncertainty intervals are plotted.
  default: `:$(getdefault("uncertainty_type"))`
- `quantiles`: The lower and upper quantile for uncertainty intervals.
  default: `$(getdefault("quantiles"))`
- `aggregate_fun`: A function that aggregates MCMC samples. The provided function must take
  a vector as input and output a scalar value.
  If `aggregate_fun = nothing` no aggregate is plotted.
  default: $(getdefault("aggregate_fun"))
"""
const item_information_curve = iteminformationcurve

"""
    item_information_curve!(model, item, response)
    item_information_curve!(model, item)

The mutating variant of [`item_information_curve`](@ref).
"""
const item_information_curve! = iteminformationcurve!
