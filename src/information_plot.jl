"""
    information_plot(model::ItemResponseModel)
    information_plot(model::ItemResponseModel, items)

Create a plot of the test information for `model`

If `items` is specified, the test information is plotted according to the subtest including
only `items`.
if `items` is omitted, the test information is plotted for all items included in `model`.

# Plot attributes
## Generic
- `color`: The color of the information plot.
- `uncertainty_color`: The color of the displayed uncertainty information.
  For plots with uncertainty intervals this is the color of the confidence band.
  For plots with sample based uncertainty information this is the line color of the samples.
- `theta`: The values of `theta` for which to plot the information.
  default: $(getdefault("theta")).
- `scoring_function`: The scoring function applied to the information.

## Specific
### Models with `SamplingEstimate`
- `samples`: The number of samples to plot. default: $(getdefault("samples")).
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
@recipe(InformationPlot) do scene
    return Attributes(;
        default_theme(scene)...,
        # generic
        color = theme(scene, :linecolor),
        palette = theme(scene, :palette),
        uncertainty_color = colorant"#bdbdbd",
        cycle = [:color],
        theta = getdefault("theta"),
        scoring_function = identity,
        # SamplingEstimate
        samples = getdefault("samples"),
        uncertainty_type = getdefault("uncertainty_type"),
        quantiles = getdefault("quantiles"),
        aggregate_fun = getdefault("aggregate_fun"),
    )
end

function Makie.plot!(ip::InformationPlot{<:Tuple{<:ItemResponseModel,Any}})
    # parse arguments
    model = ip[1]
    items = ip[2]
    rt, pd, id, et = modeltraits(model[])

    info = test_information(rt, pd, id, et, ip, items)

    plot_ip_uncertainty!(rt, pd, id, et, ip, info)
    plot_ip_aggregate!(rt, pd, id, et, ip, info)

    return ip
end

function Makie.plot!(ip::InformationPlot{<:Tuple{<:ItemResponseModel}})
    model = ip[1]
    rt, pd, id, et = modeltraits(model[])

    info = test_information(rt, pd, id, et, ip)

    plot_ip_uncertainty!(rt, pd, id, et, ip, info)
    plot_ip_aggregate!(rt, pd, id, et, ip, info)

    return ip
end

function test_information(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{PointEstimate},
    ip,
    items,
)
    thetas = ip.theta
    model = ip[1]
    scoring_function = ip.scoring_function[]

    info = [information(model[], theta, items[]; scoring_function) for theta in thetas[]]
    return info
end

function test_information(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{PointEstimate},
    ip,
)
    thetas = ip.theta
    model = ip[1]
    scoring_function = ip.scoring_function[]
    info = [information(model[], theta; scoring_function) for theta in thetas[]]
    return info
end

function test_information(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{SamplingEstimate},
    ip,
    items,
)
    thetas = ip.theta
    model = ip[1]
    scoring_function = ip.scoring_function[]

    nsamples = size(model[].pars, 1)
    n = ifelse(ip.uncertainty_type == :samples, ip.samples[], nsamples)
    iter = sample(1:nsamples, n, replace = false)

    info = Matrix{Float64}(undef, length(thetas[]), n)

    for (i, theta) in enumerate(thetas[])
        info[i, :] .= information(model[], theta, items[]; scoring_function)[iter]
    end

    return info
end

function test_information(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{SamplingEstimate},
    ip,
)
    thetas = ip.theta
    model = ip[1]
    scoring_function = ip.scoring_function[]

    nsamples = size(model[].pars, 1)
    n = ifelse(ip.uncertainty_type == :samples, ip.samples[], nsamples)
    iter = sample(1:nsamples, n, replace = false)

    info = Matrix{Float64}(undef, length(thetas[]), n)

    for (i, theta) in enumerate(thetas[])
        info[i, :] .= information(model[], theta; scoring_function)[iter]
    end

    return info
end

function plot_ip_uncertainty!(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{PointEstimate},
    ip,
    scores,
)
    return nothing
end

function plot_ip_uncertainty!(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{SamplingEstimate},
    ip,
    scores,
)
    if ip.uncertainty_type[] == :samples
        for iter in eachcol(scores)
            lines!(ip, ip.theta[], iter, color = ip.uncertainty_color[])
        end
    elseif ip.uncertainty_type[] == :interval
        q = [quantile(col, ip.quantiles[]) for col in eachrow(scores)]
        lower = first.(q)
        upper = last.(q)
        band!(ip, ip.theta[], lower, upper, color = ip.uncertainty_color[])
    end
    return nothing
end

function plot_ip_aggregate!(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{PointEstimate},
    ip,
    scores,
)
    return lines!(ip, ip.theta[], scores; cycle = ip.cycle[], color = ip.color[])
end

function plot_ip_aggregate!(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{SamplingEstimate},
    ip,
    scores,
)
    if !isnothing(ip.aggregate_fun[])
        f = ip.aggregate_fun[]
        agg = map(f, eachrow(scores))
        lines!(ip, ip.theta[], agg, cycle = ip.cycle[], color = ip.color[])
    end
    return nothing
end

const information_plot = informationplot
const information_plot! = informationplot!
