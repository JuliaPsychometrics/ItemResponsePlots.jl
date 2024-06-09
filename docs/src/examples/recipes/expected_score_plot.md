# expected\_score\_plot

```@docs; canonical=false
expected_score_plot
```

## From ItemResponseFunctions.jl
### Dichotomous items
```@example expected-score-1
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

items = [
    (a = 0.3, b = 0.0),
    (a = 2.1, b = 1.3),
    (a = 1.0, b = -0.8),
    (a = 1.2, b = -1.5)
]

expected_score_plot(TwoPL, items)

save("expected-score-1.png", current_figure(), px_per_unit = 2, size = (500, 300))  # hide
nothing  # hide
```

![](expected-score-1.png)

### Polytomous items
```@example expected-score-2
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

items = [
    (a = 1.2, b = 0.0, t = randn(3)),
    (a = 2.1, b = 0.0, t = randn(4)),
    (a = 0.6, b = 0.0, t = randn(2))
]

expected_score_plot(GPCM, items)

save("expected-score-2.png", current_figure(), px_per_unit = 2, size = (500, 300))  # hide
nothing  # hide
```

![](expected-score-2.png)

```@example expected-score-3
using CairoMakie
using ItemResponsePlots
using ItemResponseFunctions

items = [
    (b = 0.0, t = randn(2)),
    (b = 0.0, t = randn(2)),
    (b = 0.0, t = randn(2))
]

expected_score_plot(RSM, items; scoring_function = partial_credit(3))

save("expected-score-3.png", current_figure(), px_per_unit = 2, size = (500, 300))  # hide
nothing  # hide
```

![](expected-score-3.png)
