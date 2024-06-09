# item\_characteristic\_curve

```@docs; canonical=false
item_characteristic_curve
```

## From ItemResponseFunctions.jl
### Dichotomous items
```@example icc-1
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

item = (a = 1.87, b = 0.22)

item_characteristic_curve(TwoPL, item)

save("icc-1.png", current_figure(), px_per_unit = 2, size = (500, 300)) #hide
nothing # hide
```

![](icc-1.png)

```@example icc-2
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

item = (a = 0.65, b = -0.3)

item_characteristic_curve(TwoPL, item, 0)

save("icc-2.png", current_figure(), px_per_unit = 2, size = (500, 300)) #hide
nothing # hide
```

![](icc-2.png)

### Polytomous items
```@example icc-3
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

item = (a = 0.9, b = 0.0, t = (0.0, -0.2, 1.0))

item_characteristic_curve(GPCM, item)

save("icc-3.png", current_figure(), px_per_unit = 2, size = (500, 300)) #hide
nothing # hide
```

![](icc-3.png)

```@example icc-4
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

item = (a = 1.8, b = 0.1, t = (0.0, 1.0))

item_characteristic_curve(GPCM, item, 2)

save("icc-4.png", current_figure(), px_per_unit = 2, size = (500, 300)) #hide
nothing # hide
```

![](icc-4.png)
