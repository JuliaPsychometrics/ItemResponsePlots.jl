"""
    information_plot(model::ItemResponseModel, items)
"""
MakieCore.@recipe(InformationPlot) do scene
    return MakieCore.Attributes(
        # generic
        color = colorant"#10b981",
        theta = getdefault("theta"),
        # SamplingEstimate
        samples = getdefault("samples"),
    )
end

function MakieCore.plot!(ip::InformationPlot{<:Tuple{<:ItemResponseModel,Any}})
    # parse arguments
    model = ip[1]

    rt = response_type(model[])
    pd = person_dimensionality(model[])
    id = item_dimensionality(model[])
    et = estimation_type(model[])

    ip = _information_plot_item_subset(rt, pd, id, et, ip)

    return ip
end

function _information_plot_item_subset(
    ::Type{Dichotomous},
    ::Type{<:Dimensionality},
    ::Type{<:Dimensionality},
    ::Type{PointEstimate},
    ip,
)
    model = ip[1]
    items = ip[2]
    info = [information(model[], theta, items[]) for theta in ip.theta[]]
    lines!(ip, ip.theta[], info, color = ip.color)
    return ip
end

function _information_plot_item_subset(
    ::Type{Dichotomous},
    ::Type{<:Dimensionality},
    ::Type{<:Dimensionality},
    ::Type{SamplingEstimate},
    ip,
)
    model = ip[1]
    items = ip[2]
    nsamples = size(model[].pars, 1)
    n = ip.samples[]
    iter = sample(1:nsamples, n, replace = false)

    info = Matrix{Float64}(undef, length(ip.theta[]), n)

    for (i, theta) in enumerate(ip.theta[])
        info[i, :] .= information(model[], theta, items[])[iter]
    end

    for iter in eachcol(info)
        lines!(ip, ip.theta[], iter, color = (ip.color, 50 / n))
    end
end

const information_plot = informationplot
const information_plot! = informationplot!
