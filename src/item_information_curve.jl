MakieCore.@recipe(ItemInformationCurve) do scene
    MakieCore.Attributes(
        color=colorant"#10b981",
        samples=1000,
        theta=-3:0.01:3
    )
end

function MakieCore.plot!(iic::ItemInformationCurve{<:Tuple{<:ItemResponseModel,Int}})
    # parse arguments
    model = iic[1]

    rt = response_type(model[])
    pd = person_dimensionality(model[])
    id = item_dimensionality(model[])
    et = estimation_type(model[])

    iic = _item_information_curve(rt, pd, id, et, iic)
    return iic
end

function _item_information_curve(::Type{Dichotomous}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{SamplingEstimate}, iic)
    model = iic[1]
    item = iic[2]
    nsamples = size(model[].pars, 1)
    n = iic.samples[]
    iter = sample(1:nsamples, n, replace=false)

    probs = Matrix{Float64}(undef, length(iic.theta[]), n)

    for (i, theta) in enumerate(iic.theta[])
        probs[i, :] .= iif(model[], theta, item[], 1)[iter]
    end

    for iter in eachcol(probs)
        lines!(iic, iic.theta[], iter, color=(iic.color, 50 / n))
    end

    return iic
end

function _item_information_curve(::Type{Dichotomous}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{PointEstimate}, iic)
    model = iic[1]
    item = iic[2]
    probs = [iif(model[], theta, item[], 1) for theta in iic.theta[]]
    lines!(iic, iic.theta[], probs, color=iic.color)
    return iic
end

const item_information_curve = iteminformationcurve
const item_information_curve! = iteminformationcurve!
