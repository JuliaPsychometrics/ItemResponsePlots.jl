using ItemResponsePlots
using Documenter

DocMeta.setdocmeta!(
    ItemResponsePlots,
    :DocTestSetup,
    :(using ItemResponsePlots);
    recursive = true,
)

makedocs(;
    modules = [ItemResponsePlots],
    authors = "Philipp Gewessler",
    repo = "https://github.com/JuliaPsychometrics/ItemResponsePlots.jl/blob/{commit}{path}#{line}",
    sitename = "ItemResponsePlots.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://JuliaPsychometrics.github.io/ItemResponsePlots.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = ["Home" => "index.md"],
)

deploydocs(;
    repo = "github.com/JuliaPsychometrics/ItemResponsePlots.jl",
    devbranch = "main",
)
