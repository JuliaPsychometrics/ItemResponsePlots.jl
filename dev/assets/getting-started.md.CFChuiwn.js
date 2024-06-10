import{_ as s,c as e,o as a,a6 as t}from"./chunks/framework.BaW88Zjl.js";const i="/ItemResponsePlots.jl/dev/assets/getting-started-1.k7sCt_JM.png",n="/ItemResponsePlots.jl/dev/assets/getting-started-2.BcNxb8Pp.png",E=JSON.parse('{"title":"Getting started","description":"","frontmatter":{},"headers":[],"relativePath":"getting-started.md","filePath":"getting-started.md","lastUpdated":null}'),l={name:"getting-started.md"},o=t(`<h1 id="Getting-started" tabindex="-1">Getting started <a class="header-anchor" href="#Getting-started" aria-label="Permalink to &quot;Getting started {#Getting-started}&quot;">​</a></h1><p>After successful <a href="/ItemResponsePlots.jl/dev/index#Installation">installation</a> you can start plotting your item response models. Typically visualizations of item response models are made from models fitted to data. In this simple example we will fit a Rasch Model to simulated data and plot the results.</p><h2 id="Fitting-the-model" tabindex="-1">Fitting the model <a class="header-anchor" href="#Fitting-the-model" aria-label="Permalink to &quot;Fitting the model {#Fitting-the-model}&quot;">​</a></h2><p>Using the <a href="https://github.com/juliapsychometrics/RaschModels.jl" target="_blank" rel="noreferrer">RaschModels.jl</a> package we can fit a simple Rasch Model to dichotomous responses from 100 persons to 5 items.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> RaschModels</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">n_persons </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 100</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">n_items </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 5</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">data </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> rand</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, n_persons, n_items)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">model </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> fit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(RaschModel, data, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">CML</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">())</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>RaschModels.RaschModel{AbstractItemResponseModels.PointEstimate, Matrix{Int64}, RaschModels.CombinedCMLResult{NamedArrays.NamedVector{Float64, Vector{Float64}, Tuple{OrderedCollections.OrderedDict{Symbol, Int64}}}}}([0 0 … 1 0; 1 1 … 1 1; … ; 1 1 … 1 0; 1 1 … 1 1], RaschModels.CombinedCMLResult{NamedArrays.NamedVector{Float64, Vector{Float64}, Tuple{OrderedCollections.OrderedDict{Symbol, Int64}}}}(RaschModels.RaschModel, [-0.057609246355178244, -0.2981237302490657, 0.022007627285807428, -0.1372860342395019, 0.4710113835579384, -0.3454274699650454, 2.437640821721315, 1.1204355783851385, 1.1204355783851385, 0.3420951756537258  …  0.3420951756537258, 1.1204355783851385, -0.3454274699650454, -0.3454274699650454, -0.3454274699650454, -0.3454274699650454, -0.3454274699650454, 1.1204355783851385, 1.1204355783851385, 1.1204355783851385], RaschModels.CMLResult{NamedArrays.NamedVector{Float64, Vector{Float64}, Tuple{OrderedCollections.OrderedDict{Symbol, Int64}}}, Optim.MultivariateOptimizationResults{Optim.BFGS{LineSearches.InitialStatic{Float64}, LineSearches.HagerZhang{Float64, Base.RefValue{Bool}}, Nothing, Nothing, Optim.Flat}, Vector{Float64}, Float64, Float64, Vector{Optim.OptimizationState{Float64, Optim.BFGS{LineSearches.InitialStatic{Float64}, LineSearches.HagerZhang{Float64, Base.RefValue{Bool}}, Nothing, Nothing, Optim.Flat}}}, Bool, @NamedTuple{f_limit_reached::Bool, g_limit_reached::Bool, h_limit_reached::Bool, time_limit::Bool, callback::Bool, f_increased::Bool}}}(RaschModels.RaschModel, [-0.057609246355178244, -0.2981237302490657, 0.022007627285807428, -0.1372860342395019, 0.4710113835579384],  * Status: success</span></span>
<span class="line"><span></span></span>
<span class="line"><span> * Candidate solution</span></span>
<span class="line"><span>    Final objective value:     1.913512e+02</span></span>
<span class="line"><span></span></span>
<span class="line"><span> * Found with</span></span>
<span class="line"><span>    Algorithm:     BFGS</span></span>
<span class="line"><span></span></span>
<span class="line"><span> * Convergence measures</span></span>
<span class="line"><span>    |x - x&#39;|               = 1.42e-06 ≰ 0.0e+00</span></span>
<span class="line"><span>    |x - x&#39;|/|x&#39;|          = 2.69e-06 ≰ 0.0e+00</span></span>
<span class="line"><span>    |f(x) - f(x&#39;)|         = 5.02e-11 ≰ 0.0e+00</span></span>
<span class="line"><span>    |f(x) - f(x&#39;)|/|f(x&#39;)| = 2.62e-13 ≰ 0.0e+00</span></span>
<span class="line"><span>    |g(x)|                 = 2.72e-11 ≤ 1.0e-08</span></span>
<span class="line"><span></span></span>
<span class="line"><span> * Work counters</span></span>
<span class="line"><span>    Seconds run:   0  (vs limit Inf)</span></span>
<span class="line"><span>    Iterations:    5</span></span>
<span class="line"><span>    f(x) calls:    11</span></span>
<span class="line"><span>    ∇f(x) calls:   11</span></span>
<span class="line"><span>, -191.35122068988218, 4, RaschModels.ESF{Float64}([1.0, 4.867727866888627, 9.352037000566776, 8.849908741396577, 4.115326537948816, 0.7497269302303863], [1.0 1.2719033558090262 … 1.082936992747207 0.5894174339821787; 3.8677278668886275 4.573541262542496 … 4.098690047419783 2.521710757142903; … ; 0.7497269302303863 0.7497269302303863 … 0.7497269302303864 0.7497269302303863; 0.0 0.0 … 0.0 0.0], [1.0 0.0 … 0.0 0.0; 3.8677278668886275 1.2719033558090262 … 1.082936992747207 0.5894174339821787; … ; 0.7497269302303863 0.7497269302303863 … 0.7497269302303863 0.7497269302303863; 0.0 0.0 … 0.0 0.0;;; 0.0 1.2719033558090262 … 0.0 0.0; 1.2719033558090262 4.573541262542496 … 1.3773911952049076 0.7496820122542783; … ; 0.7497269302303863 0.7497269302303863 … 0.7497269302303864 0.7497269302303864; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.0; 0.9234700843502155 1.1745646992742835 … 1.000059916038232 0.5443093674770102; … ; 0.7497269302303863 0.7497269302303863 … 0.7497269302303864 0.7497269302303864; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 1.082936992747207 0.0; 1.082936992747207 1.3773911952049076 … 4.098690047419783 0.638301943429436; … ; 0.7497269302303863 0.7497269302303864 … 0.7497269302303864 0.7497269302303863; 0.0 0.0 … 0.0 0.0;;; 0.0 0.0 … 0.0 0.5894174339821787; 0.5894174339821787 0.7496820122542783 … 0.638301943429436 2.521710757142903; … ; 0.7497269302303863 0.7497269302303864 … 0.7497269302303863 0.7497269302303863; 0.0 0.0 … 0.0 0.0], 5, 6), [0.03199241312766159 -0.007955802037083105 … -0.007820436727182946 -0.008394008677822048; -0.007955802037083104 0.03253655121127882 … -0.007966052557042927 -0.008635363945133645; … ; -0.007820436727182937 -0.007966052557042929 … 0.0320723327759072 -0.008445667732659635; -0.008394008677822045 -0.008635363945133642 … -0.008445667732659637 0.03384194445398092], RaschModels.CML{RaschModels.SummationAlgorithm}(RaschModels.SummationAlgorithm(), nothing, true)), RaschModels.PersonParameterResult{RaschModels.PersonParameterWLE}(RaschModels.RaschModel, [-2.431931535208019, -1.1207147768017838, -0.3454274699650454, 0.3420951756537258, 1.1204355783851385, 2.437640821721315], [1.626667393028815, 1.0398291338156576, 0.9142513687291549, 0.9147216550140024, 1.0413478919986225, 1.6302024011317395], RaschModels.PersonParameterWLE())), [Symbol(&quot;beta[1]&quot;), Symbol(&quot;beta[2]&quot;), Symbol(&quot;beta[3]&quot;), Symbol(&quot;beta[4]&quot;), Symbol(&quot;beta[5]&quot;)])</span></span></code></pre></div><h2 id="Plotting-results" tabindex="-1">Plotting results <a class="header-anchor" href="#Plotting-results" aria-label="Permalink to &quot;Plotting results {#Plotting-results}&quot;">​</a></h2><p>Having fit the model we can now plot the results. In this example we create a plot for the whole test (5 items) by calling the <a href="/ItemResponsePlots.jl/dev/examples/plots/testplot#testplot"><code>testplot</code></a> function.</p><p><a href="/ItemResponsePlots.jl/dev/examples/plots/testplot#testplot"><code>testplot</code></a> only requires the fitted model (<code>model</code>) as the single function argument.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> CairoMakie</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> ItemResponsePlots</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">testplot</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(model)</span></span></code></pre></div><p><img src="`+i+`" alt=""></p><p>The plot above contains the test characteristic curve on the left and the test information curve on the right.</p><p>If we are interested in only a subset of items, we can plot this subset by passing a set of indices to <a href="/ItemResponsePlots.jl/dev/examples/plots/testplot#testplot"><code>testplot</code></a> in the second argument.</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">items </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> [</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">5</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">]</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">testplot</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(model, items)</span></span></code></pre></div><p><img src="`+n+'" alt=""></p><h2 id="How-to-continue-from-here?" tabindex="-1">How to continue from here? <a class="header-anchor" href="#How-to-continue-from-here?" aria-label="Permalink to &quot;How to continue from here? {#How-to-continue-from-here?}&quot;">​</a></h2><p>If you are interested in ways to expand on the example above, you can take a look at the function reference for <a href="/ItemResponsePlots.jl/dev/examples/plots/testplot#testplot"><code>testplot</code></a> and its building blocks <a href="/ItemResponsePlots.jl/dev/examples/recipes/expected_score_plot#expected_score_plot"><code>expected_score_plot</code></a> and <a href="/ItemResponsePlots.jl/dev/examples/recipes/information_plot#information_plot"><code>information_plot</code></a>.</p><p>If you want to see more examples of item response plots, consider the <a href="./getting-started">Examples</a> page of this documentation.</p>',18),p=[o];function h(r,d,c,k,m,g){return a(),e("div",null,p)}const y=s(l,[["render",h]]);export{E as __pageData,y as default};