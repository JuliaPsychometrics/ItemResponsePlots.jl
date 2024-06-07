using ItemResponsePlots
using Documenter
using DocumenterVitepress

makedocs(
    sitename = "ItemResponsePlots.jl",
    authors = "Philipp Gewessler",
    modules = [ItemResponsePlots],
    warnonly = true,
    checkdocs = :all,
    format = DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/JuliaPsychometrics/ItemResponsePlots.jl",
        devbranch = "main",
        devurl = "dev",
    ),
    clean = true,
    draft = false,
    source = "src",
    build = "build",
    pages = [
        "Home" => "index.md",
        "Getting Started" => "getting-started.md",
        "Examples" => [
            "Recipes" => [],
            "Plots" => [
                "itemplot" => "examples/plots/itemplot.md",
                "testplot" => "examples/plots/testplot.md",
            ],
        ],
        "Guides" => ["Creating the Hero Image" => "guides/creating_hero_image.md"],
        "API" => "api.md",
    ],
)

deploydocs(;
    repo = "github.com/JuliaPsychometrics/ItemResponsePlots.jl",
    target = "build",
    branch = "gh-pages",
    devbranch = "main",
    push_preview = true,
)
