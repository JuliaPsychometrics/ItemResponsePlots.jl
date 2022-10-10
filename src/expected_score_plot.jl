MakieCore.@recipe(ExpectedScorePlot) do scene
    MakieCore.Attributes(
        color=colorant"#10b981",
        samples=1000,
        theta=-3:0.01:3
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
