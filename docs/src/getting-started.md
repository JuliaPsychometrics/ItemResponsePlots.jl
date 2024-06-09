# Getting started

After successful [installation](/index#Installation) you can start plotting your item response models.
Typically visualizations of item response models are made from models fitted to data.
In this simple example we will fit a Rasch Model to simulated data and plot the results.

## Fitting the model
Using the [RaschModels.jl](https://github.com/juliapsychometrics/RaschModels.jl) package we can fit a simple Rasch Model to dichotomous responses from 100 persons to 5 items.

```@example getting-started
using RaschModels

n_persons = 100
n_items = 5

data = rand(0:1, n_persons, n_items)
model = fit(RaschModel, data, CML())
```

## Plotting results
Having fit the model we can now plot the results.
In this example we create a plot for the whole test (5 items) by calling the [`testplot`](@ref) function.

[`testplot`](@ref) only requires the fitted model (`model`) as the single function argument.

```@example getting-started
using CairoMakie
using ItemResponsePlots

testplot(model)

save("getting-started-1.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](getting-started-1.png)

The plot above contains the test characteristic curve on the left and the test information curve on the right. 

If we are interested in only a subset of items, we can plot this subset by passing a set of indices to [`testplot`](@ref) in the second argument.

```@example getting-started
items = [1, 2, 5]
testplot(model, items)

save("getting-started-2.png", current_figure(), px_per_unit = 2, size = (800, 400))  # hide
nothing  # hide
```

![](getting-started-2.png)

## How to continue from here? 

If you are interested in ways to expand on the example above, you can take a look at the function reference for [`testplot`](@ref) and its building blocks [`expected_score_plot`](@ref) and [`information_plot`](@ref).

If you want to see more examples of item response plots, consider the [Examples](#) page of this documentation.
