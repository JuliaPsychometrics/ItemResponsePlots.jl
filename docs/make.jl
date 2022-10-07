using ItemResponseRecipes
using Documenter

DocMeta.setdocmeta!(ItemResponseRecipes, :DocTestSetup, :(using ItemResponseRecipes); recursive=true)

makedocs(;
    modules=[ItemResponseRecipes],
    authors="Philipp Gewessler",
    repo="https://github.com/JuliaPsychometrics/ItemResponseRecipes.jl/blob/{commit}{path}#{line}",
    sitename="ItemResponseRecipes.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaPsychometrics.github.io/ItemResponseRecipes.jl",
        edit_link="main",
        assets=String[]
    ),
    pages=[
        "Home" => "index.md",
    ]
)

deploydocs(;
    repo="github.com/JuliaPsychometrics/ItemResponseRecipes.jl",
    devbranch="main"
)
