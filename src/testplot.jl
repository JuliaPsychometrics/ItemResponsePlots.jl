"""
    testplot(model::ItemResponseModel, args...; kwargs...)

Create a plot for test characteristics of `model`.

The resulting plot contains the test characteristic curve/expected scores (left) and the
test information curve (right).

The additional `args...` and `kwargs...` are passed to the lower level plotting functions
[`expectedscoreplot`](@ref) and [`informationplot`](@ref).
"""
function testplot(model::ItemResponseModel, args...; kwargs...)
    fig = Figure()

    if length(args) > 0
        title_items = " for items $(first(args))"
    else
        title_items = ""
    end
    # title
    Label(fig[0, 1:2], "Test plot$title_items", font = :bold)

    # expected scores
    axis_esp = Axis(
        fig[1, 1],
        title = "expected score",
        xlabel = "ability",
        ylabel = "score",
        yrectzoom = false,
        ypanlock = true,
        yzoomlock = true,
        xautolimitmargin = (0.0, 0.0),
    )

    expected_score_plot!(axis_esp, model, args...; kwargs...)
    ylims!(axis_esp, 0, nothing)

    # test information
    axis_tif = Axis(
        fig[1, 2],
        title = "test information",
        xlabel = "ability",
        ylabel = "information",
        yrectzoom = false,
        ypanlock = true,
        yzoomlock = true,
        yaxisposition = :right,
        xautolimitmargin = (0.0, 0.0),
    )

    information_plot!(axis_tif, model, args...; kwargs...)
    ylims!(axis_tif, 0, nothing)

    # general
    linkxaxes!(axis_esp, axis_tif)

    return fig
end
