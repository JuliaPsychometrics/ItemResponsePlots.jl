"""
    expected_score_plot(model::ItemResponseModel)
    expected_score_plot(model::ItemResponseModel, items)

Create a plot of the expected score for `model`.

If `items` is specified, the expected score is plotted according to the subtest including
only `items`.
If `items` is omitted, the expected score is plotted for all items included in `model`.

# Plot attributes
## Generic
- `color`: The color of the expected score plot.
- `uncertainty_color`: The color of the displayed uncertainty information.
  For plots with uncertainty intervals this is the color of the confidence band.
  For plots with sample based uncertainty information this is the line color of the samples.
- `theta`: The values of `theta` for which to plot the expected scores.
  default: $(getdefault("theta")).
- `scoring_function`: The scoring function applied to the expected scores.

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
@recipe(ExpectedScorePlot) do scene
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

function Makie.plot!(esp::ExpectedScorePlot{<:Tuple{<:ItemResponseModel,Any}})
    # parse arguments
    model = esp[1]
    items = esp[2]
    rt, pd, id, et = modeltraits(model[])

    scores = expected_scores(rt, pd, id, et, esp, items)

    plot_esp_uncertainty!(rt, pd, id, et, esp, scores)
    plot_esp_aggregate!(rt, pd, id, et, esp, scores)

    return esp
end

function Makie.plot!(esp::ExpectedScorePlot{<:Tuple{<:ItemResponseModel}})
    # parse arguments
    model = esp[1]
    rt, pd, id, et = modeltraits(model[])

    scores = expected_scores(rt, pd, id, et, esp)

    plot_esp_uncertainty!(rt, pd, id, et, esp, scores)
    plot_esp_aggregate!(rt, pd, id, et, esp, scores)

    return esp
end

function expected_scores(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{PointEstimate},
    esp,
    items,
)
    thetas = esp.theta
    model = esp[1]
    scoring_function = esp.scoring_function[]

    scores =
        [expected_score(model[], theta, items[]; scoring_function) for theta in thetas[]]
    return scores
end

function expected_scores(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{PointEstimate},
    esp,
)
    thetas = esp.theta
    model = esp[1]
    scoring_function = esp.scoring_function[]
    scores = [expected_score(model[], theta; scoring_function) for theta in thetas[]]
    return scores
end

function expected_scores(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{SamplingEstimate},
    esp,
    items,
)
    thetas = esp.theta
    model = esp[1]
    scoring_function = esp.scoring_function[]

    nsamples = size(model[].pars, 1)
    n = ifelse(esp.uncertainty_type == :samples, esp.samples[], nsamples)
    iter = sample(1:nsamples, n, replace = false)

    scores = Matrix{Float64}(undef, length(thetas[]), n)

    for (i, theta) in enumerate(thetas[])
        scores[i, :] .= expected_score(model[], theta, items[]; scoring_function)[iter]
    end

    return scores
end

function expected_scores(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{SamplingEstimate},
    esp,
)
    thetas = esp.theta
    model = esp[1]
    scoring_function = esp.scoring_function[]

    nsamples = size(model[].pars, 1)
    n = ifelse(esp.uncertainty_type == :samples, esp.samples[], nsamples)
    iter = sample(1:nsamples, n, replace = false)

    scores = Matrix{Float64}(undef, length(thetas[]), n)

    for (i, theta) in enumerate(thetas[])
        scores[i, :] .= expected_score(model[], theta; scoring_function)[iter]
    end

    return scores
end

function plot_esp_uncertainty!(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{PointEstimate},
    esp,
    scores,
)
    return nothing
end

function plot_esp_uncertainty!(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{SamplingEstimate},
    esp,
    scores,
)
    if esp.uncertainty_type[] == :samples
        for iter in eachcol(scores)
            lines!(esp, esp.theta[], iter, color = esp.uncertainty_color[])
        end
    elseif esp.uncertainty_type[] == :interval
        q = [quantile(col, esp.quantiles[]) for col in eachrow(scores)]
        lower = first.(q)
        upper = last.(q)
        band!(esp, esp.theta[], lower, upper, color = esp.uncertainty_color[])
    end
    return nothing
end

function plot_esp_aggregate!(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{PointEstimate},
    esp,
    scores,
)
    return lines!(esp, esp.theta[], scores; cycle = esp.cycle[], color = esp.color[])
end

function plot_esp_aggregate!(
    ::Type{<:ResponseType},
    ::Type{Univariate},
    ::Type{<:Dimensionality},
    ::Type{SamplingEstimate},
    esp,
    scores,
)
    if !isnothing(esp.aggregate_fun[])
        f = esp.aggregate_fun[]
        agg = map(f, eachrow(scores))
        lines!(esp, esp.theta[], agg, cycle = esp.cycle[], color = esp.color[])
    end
    return nothing
end

const expected_score_plot = expectedscoreplot
const expected_score_plot! = expectedscoreplot!
