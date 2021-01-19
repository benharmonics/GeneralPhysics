### A Pluto.jl notebook ###
# v0.12.18

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
	x::Float64	# Prey population on year 1
	y::Float64	# Predator population on year 1
	α::Float64 	# Prey growth factor per year
	β::Float64 	# Prey death factor per year
	δ::Float64	# Predator growth factor per year
	γ::Float64 	# Predator death factor per year
end

# ╔═╡ 839c59c0-5a1f-11eb-24c4-c7a3de982ca9
html"<h5>Time step of 3x a month. The choice is arbitrary.</h5>"

# ╔═╡ 13e4e050-5a12-11eb-1764-cf2089784c84
τ::Float64 = 1/36

# ╔═╡ a1bc2480-5a1f-11eb-1238-cd6e072da32a
html"<h5>The actual Lotka-Volterra differential equation:</h5>"

# ╔═╡ 2bb5867e-5a12-11eb-135c-cf6728140506
function step!(l::LotkaVolterra)
	l.x += τ*(l.α*l.x - l.β*l.x*l.y)
	l.y += τ*(l.δ*l.x*l.y - l.γ*l.y)
end

# ╔═╡ b5717610-5a1f-11eb-03b8-5783009fa91f
html"<h5>Setting things up for plotting:</h5>"

# ╔═╡ 2ac5e370-5a1f-11eb-1966-e3f612893e56
begin
	maxsteps::Int64 = 6000
	maxplots::Int64 = 200
	plotstep::Int64 = maxsteps ÷ maxplots
	xplot = Array{Float64, 1}(undef, maxplots)
	yplot = Array{Float64, 1}(undef, maxplots)
	tplot = Array{Float64, 1}(undef, maxplots)
end

# ╔═╡ c845dd80-5a1f-11eb-0ae1-41ce8fdd7be7
html"<h5>Using real information about baboon/cheetah populations over time, we finally numerically solve the equations:</h5>"

# ╔═╡ b144a830-5a12-11eb-3c23-9338902fef1e
begin
	lv = LotkaVolterra(x=10.0, y=10.0, α=1.1, β=0.4, δ=0.4, γ=0.1)
	local iplot::Int64 = 1
	for i ∈ 1:maxsteps
		if i%plotstep == 1
			xplot[iplot] = lv.x
			yplot[iplot] = lv.y
			tplot[iplot] = τ*i
			iplot += 1
		end
		step!(lv)
	end
end

# ╔═╡ fdc4e570-5a13-11eb-126a-df201e5b7370
begin
	plot(tplot, xplot, label="Baboon Population", lw=2)
	plot!(tplot, yplot, label="Cheetah Population", lw=2)
	plot!(title="Lotka-Volterra Equations", 
		xlabel="Time (years)", ylabel="Population")
end

# ╔═╡ fd1f6030-5a1f-11eb-3c28-7d0a32456864
html"<h5>Now, quickly, a less extreme example:</h5>"

# ╔═╡ 385113b0-5a16-11eb-28c4-1bb2e294c84e
begin
	steps::Int64 = 720
	plots::Int64 = 180
	sstep::Int64 = steps ÷ plots
	x = Array{Float64, 2}(undef, 10, plots)
	y = Array{Float64, 2}(undef, 10, plots)
	t = Array{Float64, 1}(undef, plots)
	for (j, v) ∈ enumerate(0.9:0.1:1.8)
		lk = LotkaVolterra(x=v, y=v, α=2/3, β=4/3, δ=1, γ=1)
		local jplot::Int64 = 1
		for i ∈ 1:steps
			if i%sstep == 1
				x[j, jplot] = lk.x
				y[j, jplot] = lk.y
				t[jplot] = τ*i
				jplot += 1
			end
			step!(lk)
		end
	end
end

# ╔═╡ 55b5d660-5a17-11eb-3db6-8394b4373f1b
begin
	plot(t, x[1, :], label="Prey Population", lw=4)
	plot!(t, y[1, :], label="Predator Population", lw=4)
	plot!(title="Lotka-Volterra Equations",
		xlabel="Time (Years)", ylabel="Population (Thousands)")
end

# ╔═╡ 8950aca0-5a19-11eb-0e00-6f0f90f52a3f
begin
	plot(title="Lotka-Volterra Phase Portrait",
			xlabel="Prey Population (Thousands)",
			ylabel="Predator Population (Thousands)")
	for (i, v) ∈ enumerate(0.9:0.1:1.8)
		plot!(x[i, 1:100], y[i, 1:100], label="x₀=y₀=$(v)")
	end
	xₛ::Float64 = 1.0 	# point of stability: xₛ=γ/δ=1/1
	yₛ::Float64 = 0.5 	# point of stability: yₛ=α/β=(2/3)/(4/3)
	scatter!([xₛ], [yₛ], label="Equlibrium ($(xₛ), $(yₛ))")
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
# ╠═385113b0-5a16-11eb-28c4-1bb2e294c84e
# ╠═55b5d660-5a17-11eb-3db6-8394b4373f1b
# ╠═8950aca0-5a19-11eb-0e00-6f0f90f52a3f
