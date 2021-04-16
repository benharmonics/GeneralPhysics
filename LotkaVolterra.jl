### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ f643a980-5a13-11eb-1016-5f8ebc2b8370
using Plots

# ╔═╡ 13a311d0-5a11-11eb-1377-cd0b5a5ed7de
html"<h1>The Lotka-Volterra Equations</h1>"

# ╔═╡ 55724410-5a1f-11eb-2e9a-813c4e69c2b9
html"<h5>Creating struct LotkaVolterra representing quantities in the equation:</h5>"

# ╔═╡ 4f8f5730-5a11-11eb-1965-0d923a0baf77
@Base.kwdef mutable struct LotkaVolterra
	🐰::Float64	# Prey population
	🐺::Float64	# Predator population
	α::Float64 	# Prey growth factor per year
	β::Float64 	# Prey death factor per year
	δ::Float64	# Predator growth factor per year
	γ::Float64 	# Predator death factor per year
end

# ╔═╡ 839c59c0-5a1f-11eb-24c4-c7a3de982ca9
html"<h5>Time step of 3x a month. The choice is arbitrary.</h5>"

# ╔═╡ 13e4e050-5a12-11eb-1764-cf2089784c84
τ = 1/36

# ╔═╡ a1bc2480-5a1f-11eb-1238-cd6e072da32a
html"<h5>The actual Lotka-Volterra differential equation:</h5>"

# ╔═╡ 2bb5867e-5a12-11eb-135c-cf6728140506
function step!(l::LotkaVolterra)
	l.🐰 += τ*(l.α*l.🐰 - l.β*l.🐰*l.🐺)
	l.🐺 += τ*(l.δ*l.🐰*l.🐺 - l.γ*l.🐺)
end

# ╔═╡ b5717610-5a1f-11eb-03b8-5783009fa91f
html"<h5>Setting things up for plotting:</h5>"

# ╔═╡ 2ac5e370-5a1f-11eb-1966-e3f612893e56
begin
maxsteps = 6000
maxplots = 200
plotstep = maxsteps ÷ maxplots
xplot = zeros(maxplots)
yplot = zeros(maxplots)
tplot = zeros(maxplots)
end

# ╔═╡ c845dd80-5a1f-11eb-0ae1-41ce8fdd7be7
html"<h5>Using real information about baboon/cheetah populations over time, we finally numerically solve the equations:</h5>"

# ╔═╡ b144a830-5a12-11eb-3c23-9338902fef1e
let
lv = LotkaVolterra(🐰=10.0, 🐺=10.0, α=1.1, β=0.4, δ=0.4, γ=0.1)
iplot = 1
for step ∈ 1:maxsteps
	if step%plotstep == 1
		xplot[iplot] = lv.🐰
		yplot[iplot] = lv.🐺
		tplot[iplot] = τ*step
		iplot += 1
	end
	step!(lv)
end
end

# ╔═╡ fdc4e570-5a13-11eb-126a-df201e5b7370
let
plot(tplot, xplot, label="Baboon Population", lw=2)
plot!(tplot, yplot, label="Cheetah Population", lw=2)
plot!(title="Lotka-Volterra Equations", xlabel="Time (years)", ylabel="Population")
end

# ╔═╡ fd1f6030-5a1f-11eb-3c28-7d0a32456864
html"<h5>Now, quickly, a less extreme example:</h5>"

# ╔═╡ bcc7adad-03a4-49a9-9135-286fa3fc61f5
begin
steps = 720
plots = 180
pstep = steps ÷ plots
populations = 0.6:0.1:1.8
🐰 = zeros(length(populations), plots)
🐺 = zeros(length(populations), plots)
t = zeros(plots)
end

# ╔═╡ c19bd9c7-819b-437f-a628-30b2897d9958
let
for (i, pop) ∈ enumerate(populations)
	lk = LotkaVolterra(🐰=pop, 🐺=pop, α=2/3, β=4/3, δ=1, γ=1)
	iplot = 1
	for step ∈ 1:steps
		if step%pstep == 1
			🐰[i, iplot] = lk.🐰
			🐺[i, iplot] = lk.🐺
			t[iplot] = τ*step
			iplot += 1
		end
		step!(lk)
	end
end
end

# ╔═╡ 55b5d660-5a17-11eb-3db6-8394b4373f1b
let
plot(t, 🐰[1, :], label="Prey Population", lw=4)
plot!(t, 🐺[1, :], label="Predator Population", lw=4)
plot!(title="Lotka-Volterra Model", 
		xlabel="Time (Years)", ylabel="Population (Thousands)")
end

# ╔═╡ 8950aca0-5a19-11eb-0e00-6f0f90f52a3f
let
plot(title = "Lotka-Volterra Phase Portrait")
xlabel!("Prey Population (Thousands)")
ylabel!("Predator Population (Thousands)")
for (i, pop) ∈ enumerate(populations)
	plot!(🐰[i, 1:100], 🐺[i, 1:100], label="x₀=y₀=$(pop)")
end
xₛ = 1/1 			# point of stability: xₛ = γ/δ = 1/1
yₛ = (2/3)/(4/3) 	# point of stability: yₛ = α/β = (2/3)/(4/3)
scatter!([xₛ], [yₛ], label="Equlibrium ($xₛ, $yₛ)")
end

# ╔═╡ Cell order:
# ╟─13a311d0-5a11-11eb-1377-cd0b5a5ed7de
# ╟─55724410-5a1f-11eb-2e9a-813c4e69c2b9
# ╠═4f8f5730-5a11-11eb-1965-0d923a0baf77
# ╟─839c59c0-5a1f-11eb-24c4-c7a3de982ca9
# ╠═13e4e050-5a12-11eb-1764-cf2089784c84
# ╟─a1bc2480-5a1f-11eb-1238-cd6e072da32a
# ╠═2bb5867e-5a12-11eb-135c-cf6728140506
# ╟─b5717610-5a1f-11eb-03b8-5783009fa91f
# ╠═2ac5e370-5a1f-11eb-1966-e3f612893e56
# ╟─c845dd80-5a1f-11eb-0ae1-41ce8fdd7be7
# ╠═b144a830-5a12-11eb-3c23-9338902fef1e
# ╠═f643a980-5a13-11eb-1016-5f8ebc2b8370
# ╠═fdc4e570-5a13-11eb-126a-df201e5b7370
# ╟─fd1f6030-5a1f-11eb-3c28-7d0a32456864
# ╠═bcc7adad-03a4-49a9-9135-286fa3fc61f5
# ╠═c19bd9c7-819b-437f-a628-30b2897d9958
# ╠═55b5d660-5a17-11eb-3db6-8394b4373f1b
# ╠═8950aca0-5a19-11eb-0e00-6f0f90f52a3f
