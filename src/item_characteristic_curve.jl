"""
    item_characteristic_curve(model::ItemResponseModel, item, response)
    item_characteristic_curve(model::ItemResponseModel, item)

Create a plot of the item characteristic curve for `response` of `item`.

An item characteristic curve plots the probability for `response` of `item` given the
person ability θ.

If `response` is omitted, the default plot behaviour depends on `model`:
- For models where `response_type(model) == Dichotomous` the item characteristic curve for
  response = 1 is plotted, i.e. the probability of a correct response.
- For models where `response_type(model) <: Union{Nominal, Ordinal}` all category characteristic
  curves are plotted.

# Plot attributes
## Generic
- `color`: The color of the item characteristic curve.
- `uncertainty_color`: The color of the displayed uncertainty information.
  For plots with uncertainty intervals this is the color of the confidence band.
  For plots with sample based uncertainty information this is the line color of the samples.
- `theta`: The values of `theta` for which to plot the item characteristic curve.
  default: $(getdefault("theta")).
- `show_data`: Overlay observed data in the plot. Ability estimates are aggregated according
  to `bins`. For models with `estimation_type(model) == SamplingEstimate` the posterior means
  of ability estimates are used for binning. default: false.
- `bins`: The number of bins for the observed data. default: 6.

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
  an `x` by `iteration` matrix as input and output a vector of length `x`.
  If `aggregate_fun = nothing` no aggregate is plotted.
  default: `x -> vec(mean(x, dims=2))` (posterior mean)
"""
@recipe(ItemCharacteristicCurve) do scene
    Attributes(;
        default_theme(scene)...,
        # generic
        color=theme(scene, :linecolor),
        uncertainty_color=(colorant"#bdbdbd", 50 / getdefault("samples")),
        cycle=[:color],
        theta=getdefault("theta"),
        show_data=false,
        bins=6,
        # SamplingEstimate
        samples=getdefault("samples"),
        uncertainty_type=getdefault("uncertainty_type"),
        quantiles=getdefault("quantiles"),
        aggregate_fun=getdefault("aggregate_fun")
    )
end

function plot!(icc::ItemCharacteristicCurve{<:Tuple{<:ItemResponseModel,<:Integer,<:Real}})
    # parse arguments
    model = icc[1]
    response = icc[3]
    rt, pd, id, et = modeltraits(model[])

    checkresponsetype(rt, response[])

    probs = icc_probabilities(rt, pd, id, et, icc, response[])
    plot_icc_uncertainty!(rt, pd, id, et, icc, probs)
    plot_icc_aggregate!(rt, pd, id, et, icc, probs)

    return icc
end

function plot!(icc::ItemCharacteristicCurve{<:Tuple{<:ItemResponseModel,<:Integer}})
    model = icc[1]
    rt, pd, id, et = modeltraits(model[])

    if rt <: Dichotomous
        probs = icc_probabilities(rt, pd, id, et, icc, 1)
        plot_icc_uncertainty!(rt, pd, id, et, icc, probs)
        plot_icc_aggregate!(rt, pd, id, et, icc, probs)
    elseif rt <: Union{Nominal,Ordinal}
        responses = 1:4
        probs = [icc_probabilities(rt, pd, id, et, icc, response) for response in responses]

        # plot uncertainty intervals/samples first, so they don't overlay aggregate values
        for prob in probs
            plot_icc_uncertainty!(rt, pd, id, et, icc, prob)
        end

        for prob in probs
            plot_icc_aggregate!(rt, pd, id, et, icc, prob)
        end
    else
        error("not implemented")
    end

    return icc
end

function icc_probabilities(::Type{<:ResponseType}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{SamplingEstimate}, icc, response)
    model = icc[1]
    item = icc[2]
    nsamples = size(model[].pars, 1)
    n = ifelse(icc.uncertainty_type == :samples, icc.samples[], nsamples)
    iter = sample(1:nsamples, n, replace=false)

    probs = Matrix{Float64}(undef, length(icc.theta[]), n)

    for (i, theta) in enumerate(icc.theta[])
        probs[i, :] .= irf(model[], theta, item[], response)[iter]
    end

    return probs
end

function icc_probabilities(::Type{<:ResponseType}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{PointEstimate}, icc, response)
    model = icc[1]
    item = icc[2]
    probs = [irf(model[], theta, item[], response) for theta in icc.theta[]]
    return probs
end

function plot_icc_uncertainty!(::Type{<:ResponseType}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{SamplingEstimate}, icc, probs)
    if icc.uncertainty_type[] == :samples
        for iter in eachcol(probs)
            lines!(icc, icc.theta[], iter, color=icc.uncertainty_color[])
        end
    elseif icc.uncertainty_type[] == :interval
        q = [quantile(col, icc.quantiles[]) for col in eachrow(probs)]
        lower = first.(q)
        upper = last.(q)
        band!(icc, icc.theta[], lower, upper, color=icc.uncertainty_color[])
    end
    return nothing
end

function plot_icc_uncertainty!(::Type{<:ResponseType}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{PointEstimate}, icc, probs)
    return nothing
end

function plot_icc_aggregate!(::Type{<:ResponseType}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{SamplingEstimate}, icc, probs)
    if !isnothing(icc.aggregate_fun[])
        agg = icc.aggregate_fun[](probs)
        lines!(icc, icc.theta[], agg, color=icc.color[])
    end
    return nothing
end

function plot_icc_aggregate!(::Type{<:ResponseType}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{PointEstimate}, icc, probs)
    lines!(icc, icc.theta[], probs; cycle=icc.cycle[], color=icc.color[])
end

const item_characteristic_curve = itemcharacteristiccurve
const item_characteristic_curve! = itemcharacteristiccurve!
