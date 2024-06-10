"""
    itemplot(model, item, args...; kwargs...)

Create an item plot for `item` of `model`.

The resulting item plot contains the item characteristic curve (left) and the item
information curve (right).

The additional `args...` and `kwargs...` are passed to the lower level functions
[`item_characteristic_curve`](@ref) and [`item_information_curve`](@ref).
"""
function itemplot(model, i, args...; kwargs...)
    fig = Figure()

    # title
    Label(fig[0, 1:2], "Item plot for item $i", font = :bold)

    # item characteristic_curve
    axis_icc = Axis(
        fig[1, 1],
        title = "item characteristic curve",
        xlabel = "ability",
        ylabel = "probability",
        yrectzoom = false,
        ypanlock = true,
        yzoomlock = true,
        xautolimitmargin = (0.0, 0.0),
    )

    icc = item_characteristic_curve!(axis_icc, model, i, args...; kwargs...)
    ylims!(axis_icc, 0, 1)

    # item information curve
    axis_iic = Axis(
        fig[1, 2],
        title = "item information curve",
        xlabel = "ability",
        ylabel = "information",
        yrectzoom = false,
        ypanlock = true,
        yzoomlock = true,
        yaxisposition = :right,
        xautolimitmargin = (0.0, 0.0),
    )

    item_information_curve!(axis_iic, model, i, args...; kwargs...)
    ylims!(axis_iic, 0, nothing)

    # general
    linkxaxes!(axis_icc, axis_iic)
    Legend(fig[2, 1:2], axis_icc, orientation = :horizontal, framevisible = false)

    return fig
end
