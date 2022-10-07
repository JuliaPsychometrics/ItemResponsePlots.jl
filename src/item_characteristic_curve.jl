MakieCore.@recipe(ItemCharacteristicCurve) do scene
    MakieCore.Attributes(
        color=colorant"#10b981",
        samples=1000,
        theta=-3:0.01:3
    )
end

function MakieCore.plot!(icc::ItemCharacteristicCurve{<:Tuple{<:ItemResponseModel,Int}})
    # parse arguments
    model = icc[1]

    rt = response_type(model[])
    pd = person_dimensionality(model[])
    id = item_dimensionality(model[])
    et = estimation_type(model[])

    icc = _item_characteristic_curve(rt, pd, id, et, icc)

    # TODO: general settings

    return icc
end

function _item_characteristic_curve(::Type{Dichotomous}, ::Type{Univariate}, ::Type{<:Dimensionality}, ::Type{SamplingEstimate}, icc)
    model = icc[1]
    item = icc[2]
    nsamples = size(model[].pars, 1)
    n = icc.samples[]
    iter = sample(1:nsamples, n, replace=false)

    probs = Matrix{Float64}(undef, length(icc.theta[]), n)

    for (i, theta) in enumerate(icc.theta[])
        probs[i, :] .= irf(model[], theta, item[], 1)[iter]
    end

    for iter in eachcol(probs)
        lines!(icc, icc.theta[], iter, color=(icc.color, 50 / n))
    end

    return icc
end

const item_characteristic_curve = itemcharacteristiccurve
const item_characteristic_curve! = itemcharacteristiccurve!
