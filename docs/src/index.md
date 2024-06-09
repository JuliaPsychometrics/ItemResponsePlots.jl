```@raw html
---
layout: home

hero:
    name: ItemResponsePlots.jl
    tagline: Visualizations for item response models with Makie.jl 
    image:
        src: logo.png
        alt: ItemResponsePlots.jl
    actions:
        - theme: brand
          text: Getting started
          link: /getting-started
        - theme: alt
          text: View on Github
          link: https://github.com/JuliaPsychometrics/ItemResponsePlots.jl  
        - theme: alt
          text: Function reference
          link: /api
---
```

```@raw html
<div class="vp-doc" style="width:80%; margin:auto">
```

# What is ItemResponsePlots.jl?

ItemResponsePlots.jl is a julia package that provides plotting capabilities for item response models. 
It is developed by the [JuliaPsychometrics](https://github.com/juliapsychometrics) organization under MIT license. 

## Installation
To install this package simply use julias package management system.

```julia
] add ItemResponsePlots
```

## How do I use this package?
ItemResponsePlots.jl integrates with the interface designed in [AbstractItemResponseModels.jl](https://github.com/juliapsychometrics/AbstractItemResponseModels.jl).
This means that all packages implementing the interface can automatically use the plotting recipes and plots defined in ItemResponsePlots.jl.

Currently the list of packages includes:

- [RaschModels.jl](https://github.com/juliapsychometrics/RaschModels.jl)
- [ItemResponseFunctions.jl](https://github.com/juliapsychometrics/ItemResponseFunctions.jl)

For a fully worked example see the [Getting started](/getting-started) section.

```@raw html
</div>
```
