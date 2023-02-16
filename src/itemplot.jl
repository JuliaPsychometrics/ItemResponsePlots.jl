"""
    itemplot(model::ItemResponseModel, item, args...; kwargs...)

Create an item plot for `item` of `model`.

The resulting item plot contains the item characteristic curve (left) and the item
information curve (right).

The additional `args...` and `kwargs...` are passed to the lower level functions
[item_characteristic_curve](@ref) and [item_information_curve](@ref).
"""
function itemplot(model::ItemResponseModel, i, args...; kwargs...)
    fig = Figure()

    # item characteristic_curve
    axis_icc = Axis(
        fig[1, 1],
        title = "item characteristic curve",
        xlabel = "ability",
        ylabel = "probability",
    )

    icc = item_characteristic_curve!(axis_icc, model, i, args...; kwargs...)

    xmin = minimum(icc.attributes.theta[])
    xmax = maximum(icc.attributes.theta[])
    xlims!(axis_icc, xmin, xmax)
    ylims!(axis_icc, 0, 1)

    # item information curve
    axis_iic = Axis(
        fig[1, 2],
        title = "item information curve",
        xlabel = "ability",
        ylabel = "information",
    )

    item_information_curve!(axis_iic, model, i, args...; kwargs...)
    xlims!(axis_iic, xmin, xmax)
    ylims!(axis_iic, 0, nothing)

    # general
    linkxaxes!(axis_icc, axis_iic)

    return fig
end
