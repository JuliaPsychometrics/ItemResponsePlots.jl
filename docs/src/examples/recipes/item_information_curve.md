# item\_information\_curve

```@docs; canonical=false
item_information_curve
```

## From ItemResponseFunctions.jl
### Dichotomous items
```@example iic-1
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

item = (a = 2.17, b = 0.10, c = 0.05, d = 0.8, e = 2.33)

item_information_curve(FivePL, item)

save("iic-1.png", current_figure(), px_per_unit = 2, size = (500, 300)) #hide
nothing # hide
```

![](iic-1.png)

```@example iic-2
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

item = (; b = 0.5)

item_information_curve(OnePL, item, 0)
item_information_curve!(OnePL, item, 1)

save("iic-2.png", current_figure(), px_per_unit = 2, size = (500, 300)) #hide
nothing # hide
```

![](iic-2.png)

### Polytomous items
```@example iic-3 
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

item = (a = 1.43, b = 0.2, t = (-1.2, 0.2, 0.5, 0.9))

item_information_curve(GRSM, item)

axislegend(position = :lt)

save("iic-3.png", current_figure(), px_per_unit = 2, size = (500, 300)) #hide
nothing # hide
```

![](iic-3.png)
