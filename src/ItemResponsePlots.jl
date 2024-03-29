module ItemResponsePlots

using AbstractItemResponseModels
using Colors
using Makie
using StatsBase

import Makie: @recipe, Attributes, default_theme, theme, plot!

export getdefault, setdefault!

export item_characteristic_curve, item_characteristic_curve!
export item_information_curve, item_information_curve!
export expected_score_plot, expected_score_plot!
export information_plot, information_plot!
export itemplot
export testplot

include("utils.jl")

const DEFAULT_VALUES = Ref(
    Dict(
        "theta" => -3:0.01:3,
        "samples" => 1000,
        "uncertainty_type" => :samples,
        "quantiles" => ci(0.2),
        "aggregate_fun" => mean,
    ),
)

"""
    getdefault(attribute::String)

Fetch the default value for `attribute`.
"""
getdefault(attribute::String) = getindex(DEFAULT_VALUES[], attribute)

"""
    setdefault!(attribute::String, value)

Set a new default value for `attribute`.
"""
setdefault!(attribute::String, value) = setindex!(DEFAULT_VALUES[], value, attribute)

include("item_characteristic_curve.jl")
include("item_information_curve.jl")
include("expected_score_plot.jl")
include("information_plot.jl")

include("itemplot.jl")
include("testplot.jl")

end
