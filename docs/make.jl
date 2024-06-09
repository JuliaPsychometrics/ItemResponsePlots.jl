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
            "Recipes" => [
                "expected_score_plot" => "examples/recipes/expected_score_plot.md",
                "information_plot" => "examples/recipes/information_plot.md",
                "item_characteristic_curve" => "examples/recipes/item_characteristic_curve.md",
                "item_information_curve" => "examples/recipes/item_information_curve.md",
            ],
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
