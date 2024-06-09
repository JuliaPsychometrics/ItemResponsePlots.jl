# Creating the Hero Image
The hero image on the home page of [ItemResponsePlots.jl](/index.md) is a random collection of item characteristic curves generated from a 3-Parameter Logistic Model. It makes use of the [`item_characteristic_curve!`](@ref) recipe.

In a first step item parameters need to be generated. 
The parameter distributions are chosen to yield nicely distributed curves for display.

To make the resulting plot reproducible, a random seed is set before simulation.

```@example hero-image
using Random        
Random.seed!(43)    

using CairoMakie
using ItemResponseFunctions
using ItemResponsePlots

n_samples = 500

items = [(
    a = exp(randn() * 0.25), 
    b = randn() * 0.3, 
    c = exp(randn() * 0.33 - 2.0)
) for _ in 1:n_samples]
```

Once the item parameters (`items`) are generated, the item characteristic curves are ready to be plotted.
On the most basic level this visualization just plots each item characteristic curve in a loop - the remaining code just exists to make the plot pretty! 
Most notably, the curves are colored by the item difficulty `b`.

```@example hero-image
fig = Figure()
ax = Axis(fig[1, 1])
hidedecorations!(ax)
hidespines!(ax)

normalize(x) = (x .- minimum(x)) ./ (maximum(x) - minimum(x))

colors = normalize(getindex.(items, :b))

function get_color(i)
    col = cgrad()[colors[i]]
    alpha = 0.1
    return (col, alpha)
end

thetas = -3:0.01:3

for i in eachindex(items)
    col = get_color(i)
    item_characteristic_curve!(ax, ThreePL, items[i], color = col, theta = thetas)
end

fig

save("hero-image.png", fig, size = (600, 400))  # hide
nothing  # hide
```

![](hero-image.png)
