# ItemResponsePlots.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaPsychometrics.github.io/ItemResponseRecipes.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaPsychometrics.github.io/ItemResponseRecipes.jl/dev/)
[![Build Status](https://github.com/JuliaPsychometrics/ItemResponseRecipes.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaPsychometrics/ItemResponseRecipes.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaPsychometrics/ItemResponseRecipes.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaPsychometrics/ItemResponseRecipes.jl)

This package provides plotting capabilities for item response models implementing the [AbstractItemResponseModels.jl](https://github.com/JuliaPsychometrics/AbstractItemResponseModels.jl) interface. 

ItemResponsePlots.jl leverages the [Makie.jl](https://github.com/MakieOrg/Makie.jl) ecosystem, making it easy to extend basic figures and combine them in complex plots.

## Installation
To install this package simply use julias package management system.

```julia
] add ItemResponsePlots
```

## Getting started
After sucessfull installation you can start plotting results of your item response model. Prerequisite is a fitted `ItemResponseModel`, e.g. via [RaschModels.jl](https://github.com/JuliaPsychometrics/RaschModels.jl).

```julia
using RaschModels

data = rand(0:1, 100, 5)
rasch = fit(RaschModel, data, CML())
```

Once the parameters are estimated, simply call your desired plotting function. 

For example, item characteristic curves are implemented by the `item_characteristic_curve` function. 
To plot the item characteristic curve for item `1`, call

```julia
item_characteristic_curve(rasch, 1)
```

All plotting functions in ItemResponsePlots.jl implement a variety of customization options. For details see the relevant plotting functions help page (e.g. `?item_characteristic_curve`).

## Available plots
Currently ItemResponsePlots supports the following low-level plots,

- Item characteristic curves
- Item information curves
- Test characteristic / expected score plots
- Test information plots 
