# information\_plot

```@docs; canonical=false
information_plot
```

## From ItemResponseFunctions.jl
### Dichotomous items
```@example information-plot-1
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

items = [
    (a = 1.2, b = 0.2, c = 0.5),
    (a = 1.0, b = 1.5, c = 0.0),
    (a = 2.6, b = -0.5, c = 0.2)
]

information_plot(ThreePL, items)

save("information-1.png", current_figure(), px_per_unit = 2, size = (500, 300))  # hide
nothing  # hide
```

![](information-1.png)

### Polytomous items
```@example information-2
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

items = [
    (b = 0.0, t = rand(3)),
    (b = -0.5, t = rand(3)),
    (b = 1.0, t = rand(3))
]

information_plot(RSM, items)

save("information-2.png", current_figure(), px_per_unit = 2, size = (500, 300))  # hide
nothing  # hide
```

![](information-2.png)
