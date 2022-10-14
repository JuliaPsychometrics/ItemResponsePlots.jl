"""
    expected_score_plot(model::ItemResponseModel)
    expected_score_plot(model::ItemResponseModel, items)

Create a plot of the expected score for `model`.
If `items` is specified, the expected score is plotted according to the subtest including
only `items`.
If `items` is omitted, the expected score is plotted for all items included in `model`.

# Plot attributes
## Generic
- `color`: The color of the expected score curve.
- `theta`: The values of `theta` for which to plot the expected scores.
  default: $(getdefault("theta")).

## Specific
### Models with `SamplingEstimate`
- `samples`: The number of samples to plot. default: $(getdefault("samples")).

"""
MakieCore.@recipe(ExpectedScorePlot) do scene
    MakieCore.Attributes(
        # generic
        color=colorant"#10b981",
        theta=getdefault("theta"),
        # SamplingEstimate
        samples=getdefault("samples"),
    )
end

# with item specification
function MakieCore.plot!(esp::ExpectedScorePlot{<:Tuple{<:ItemResponseModel,Any}})
    # parse arguments
    model = esp[1]

    rt = response_type(model[])
    pd = person_dimensionality(model[])
    id = item_dimensionality(model[])
    et = estimation_type(model[])

    esp = _expected_score_plot_item_subset(rt, pd, id, et, esp)

    return esp
end

function _expected_score_plot_item_subset(::Type{Dichotomous}, ::Type{<:Dimensionality}, ::Type{<:Dimensionality}, ::Type{PointEstimate}, esp)
    model = esp[1]
    items = esp[2]
    scores = [expected_score(model[], theta, items[]) for theta in esp.theta[]]
    lines!(esp, esp.theta[], scores, color=esp.color)
    return esp
end

function _expected_score_plot_item_subset(::Type{Dichotomous}, ::Type{<:Dimensionality}, ::Type{<:Dimensionality}, ::Type{SamplingEstimate}, esp)
    model = esp[1]
    items = esp[2]
    nsamples = size(model[].pars, 1)
    n = esp.samples[]
    iter = sample(1:nsamples, n, replace=false)

    scores = Matrix{Float64}(undef, length(esp.theta[]), n)

    for (i, theta) in enumerate(esp.theta[])
        scores[i, :] .= expected_score(model[], theta, items[])[iter]
    end

    for iter in eachcol(scores)
        lines!(esp, esp.theta[], iter, color=(esp.color, 50 / n))
    end

    return esp
end

# full test
function MakieCore.plot!(esp::ExpectedScorePlot{<:Tuple{<:ItemResponseModel}})
    # parse arguments
    model = esp[1]

    rt = response_type(model[])
    pd = person_dimensionality(model[])
    id = item_dimensionality(model[])
    et = estimation_type(model[])

    esp = _expected_score_plot_full_test(rt, pd, id, et, esp)

    return esp
end

function _expected_score_plot_full_test(::Type{Dichotomous}, ::Type{<:Dimensionality}, ::Type{<:Dimensionality}, ::Type{PointEstimate}, esp)
    model = esp[1]
    scores = [expected_score(model[], theta) for theta in esp.theta[]]
    lines!(esp, esp.theta[], scores, color=esp.color)
    return esp
end

function _expected_score_plot_full_test(::Type{Dichotomous}, ::Type{<:Dimensionality}, ::Type{<:Dimensionality}, ::Type{SamplingEstimate}, esp)
    model = esp[1]
    nsamples = size(model[].pars, 1)
    n = esp.samples[]
    iter = sample(1:nsamples, n, replace=false)

    scores = Matrix{Float64}(undef, length(esp.theta[]), n)

    for (i, theta) in enumerate(esp.theta[])
        scores[i, :] .= expected_score(model[], theta)[iter]
    end

    for iter in eachcol(scores)
        lines!(esp, esp.theta[], iter, color=(esp.color, 50 / n))
    end

    return esp
end

const expected_score_plot = expectedscoreplot
const expected_score_plot! = expectedscoreplot!
