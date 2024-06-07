# itemplot
```@docs; canonical=false
itemplot
```

## From ItemResponseFunctions.jl
```@example itemplot-1
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

item = (a = 1.3, b = -2.1, c = 0.1, d = 0.67)

itemplot(FourPL, item)

save("itemplot-1.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](itemplot-1.png)

```@example itemplot-2
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

thresholds = [0.2, -1.2, 0.6]
item = (a = 1.0, b = 0.0, t = thresholds)

itemplot(GRSM, item)

save("itemplot-2.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](itemplot-2.png)

## From RaschModels.jl
### Frequentist Estimation
```@example itemplot-3
using CairoMakie
using RaschModels
using ItemResponsePlots

responses = rand(0:1, 100, 6)
model = fit(RaschModel, responses, CML())

itemplot(model, 3)

save("itemplot-3.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](itemplot-3.png)

### Bayesian Estimation
```@example itemplot-4
using CairoMakie
using RaschModels
using ItemResponsePlots

responses = rand(0:1, 100, 6)
model = fit(RaschModel, responses, NUTS(), 500, progress = false)

itemplot(model, 5, 1, uncertainty_type = :interval)

save("itemplot-4.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](itemplot-4.png)
