# testplot
```@docs; canonical=false
testplot
```

## From ItemResponseFunctions.jl
```@example testplot-1
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

items = [
    (a = 2.3, b = 1.2, c = 0.12),
    (a = 0.75, b = 0.25, c = 0.25),
    (a = 1.3, b = -2.1, c = 0.0),
    (a = 1.6, b = -0.36, c = 0.33),
]

testplot(ThreePL, items)

save("testplot-1.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](testplot-1.png)

```@example testplot-2
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

thresholds = [0.2, -1.2, 0.6]
items = [
    (a = 2.3, b = 1.2, t = thresholds),
    (a = 0.75, b = 0.25, t = thresholds),
    (a = 1.3, b = -2.1, t = thresholds),
    (a = 1.6, b = -0.36, t = thresholds),
]

testplot(GRSM, items)

save("testplot-2.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](testplot-2.png)

## From RaschModels.jl
### Frequentist Estimation
```@example testplot-3
using CairoMakie
using RaschModels
using ItemResponsePlots

responses = rand(0:1, 100, 6)
model = fit(RaschModel, responses, CML())

testplot(model)

save("testplot-3.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](testplot-3.png)

### Bayesian Estimation
```@example testplot-4
using CairoMakie
using RaschModels
using ItemResponsePlots

responses = rand(0:1, 100, 6)
model = fit(RaschModel, responses, NUTS(), 500, progress = false)

testplot(model)

save("testplot-4.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](testplot-4.png)
