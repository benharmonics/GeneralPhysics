### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 5719ba80-59c7-11eb-09d7-0b79c4fe0b8f
using Plots 	# Plotting backend

# ╔═╡ 2e943e40-59d7-11eb-1b9c-b5ec5d9cf114
html"<h1>Projectile Motion with Euler's Method</h1>"

# ╔═╡ ae334720-59de-11eb-2bb5-81773ca0f2e4
html"<h2>Setting things up for plotting</h2>"

# ╔═╡ 40e2d3e0-59d7-11eb-0a7b-9f108787b759
html"<h5>A struct to store the quantities we care about:</h5>"

# ╔═╡ 89eaa350-59c4-11eb-0187-c5ad24105f84
@Base.kwdef mutable struct Ball
	θ::Float64 				# Angle of launch above neutral, radians
	x::Float64 = 0 			# Initial (x, y) position is (0, 0), in meters
	y::Float64 = 0
	vx::Float64 = 30cos(θ) 	# 30 m/s ≈ 70 mph
	vy::Float64 = 30sin(θ)
	ax::Float64 = 0 		# Ignoring wind resistance, ax is always zero
	ay::Float64 = -9.8 		# Gravity, m/s²
	distance::Float64 = Inf # Distance travelled before landing, recorded later
end

# ╔═╡ 84ce10ae-59d7-11eb-0159-d940a49ea8f3
html"<h5>Time step:</h5>"

# ╔═╡ ccf7c2e0-59c9-11eb-2c30-05b6926c7125
τ = .001 # time step for Euler's method, seconds

# ╔═╡ 9695ea20-59d7-11eb-0295-73f37d0a1922
html"<h5>Euler's Method applied to Ball struct as step function:</h5>"

# ╔═╡ c876563e-59c5-11eb-0960-fd0d317f137e
function step!(b::Ball)
	b.vx += b.ax*τ
	b.vy += b.ay*τ
	b.x += b.vx*τ
	b.y += b.vy*τ
	if b.y <= 0 	# let's assume ball bounces perfectly elastically, for fun
		b.y = -b.y
		b.vy = -b.vy
		b.distance = b.x
	end
end

# ╔═╡ 049cdc20-59df-11eb-0219-0194a1d3ce10
html"<h5>Setting up empty arrays for plotting 3 different balls:</h5>"

# ╔═╡ fd3d4910-59ca-11eb-0533-abe0fa401cc1

begin
	maxsteps::Int64 = 6000
	maxplots::Int64 = 120
	plotstep::Int64 = maxsteps ÷ maxplots
	iplot::Int64 = 1
	
	xplot = Array{Float64, 2}(undef, 3, maxplots)
	yplot = Array{Float64, 2}(undef, 3, maxplots)
	
	b1 = Ball(θ=π/4)
	b2 = Ball(θ=π/3)
	b3 = Ball(θ=π/6)
end

# ╔═╡ c5404f30-59de-11eb-1ea5-d5e0a3378e35
html"<h2>Plotting</h2>"

# ╔═╡ e8675532-59de-11eb-20be-a94a386bfd21
html"<h5>Calling main step function:</h5>"

# ╔═╡ c65c4ee2-59d0-11eb-01cd-af3ec58fd3b8
for i ∈ 1:maxsteps
	step!(b1)
	step!(b2)
	step!(b3)
	if i%plotstep == 1
		xplot[:, iplot] = [b1.x, b2.x, b3.x]
		yplot[:, iplot] = [b1.y, b2.y, b3.y]
		iplot += 1
	end
end

# ╔═╡ 2d96f8e0-59df-11eb-118b-a7b8e259d543
html"<h5>Distance travelled before landing for each ball:</h5>"

# ╔═╡ 25419320-59d6-11eb-2d88-19eb6787edbf
b1.distance, b2.distance, b3.distance

# ╔═╡ 51237770-59df-11eb-312f-79544f3b168a
html"<h5>This is what we expect; we launched the first ball at π/4 radians, and the other two equidistant from it:</h5>"

# ╔═╡ 55c72500-59d6-11eb-1274-8b6dfb43cfb9
b1.θ, rad2deg(b1.θ) 	# first ball launched at 45°

# ╔═╡ eca1d520-59df-11eb-2dc4-d9d2779b6bc3
b1.θ - b2.θ, rad2deg(b1.θ - b2.θ) # launched at 45° + 15°

# ╔═╡ 2863fd40-59e0-11eb-16b5-991137d7867e
b1.θ - b3.θ, rad2deg(b1.θ - b3.θ) # launched at 45° - 15°

# ╔═╡ 1779f3f0-59d0-11eb-0b0d-2503afafab7d
begin
	scatter(xplot[1, :], yplot[1, :], xlims=(0, 100),
		label="θ=$(round(rad2deg(b1.θ), digits=3))°")
	scatter!(xplot[2, :], yplot[2, :],
		label="θ=$(round(rad2deg(b2.θ), digits=3))°")
	scatter!(xplot[3, :], yplot[3, :],
		label="θ=$(round(rad2deg(b3.θ), digits=3))°")
	scatter!(title="Projectile Motion Over $(τ*maxsteps) Seconds", 
		xlabel="Distance [m]", ylabel="Height [m]")
end

# ╔═╡ a34de050-59d8-11eb-0125-553fbef90785
@gif for i ∈ 1:maxplots
	scatter([xplot[1, i]], [yplot[1, i]], ylim=(0, 40), xlim=(0, 100),
	    label="θ=$(round(rad2deg(b1.θ), digits=3))°", markersize=10)
	scatter!([xplot[2, i]], [yplot[2, i]], markersize=10,
		label="θ=$(round(rad2deg(b2.θ), digits=3))°")
	scatter!([xplot[3, i]], [yplot[3, i]], markersize=10,
	    label="θ=$(round(rad2deg(b3.θ), digits=3))°")
	scatter!(title="Projectile Motion Over $(τ*maxsteps) Seconds", 
		xlabel="Distance [m]", ylabel="Height [m]")
end

# ╔═╡ 698b9b50-59e2-11eb-2686-13b813de6970
html"<h2>Try it yourself!</h2>"

# ╔═╡ 6b0f3142-59e6-11eb-3450-b30c9151ff64
html"<i>This currently only works in the Julia REPL, not on static webpages!</i>"

# ╔═╡ 74e99c40-59e2-11eb-3ae6-6d9363a2834a
html"<h5>Choose an angle of launch, α, in degrees:</h5>"

# ╔═╡ 1d761150-59e2-11eb-00b4-3b97e23069eb
@bind α html"<input type='range' min='1' max='89' step='1' value='42'>"

# ╔═╡ 9addf310-59e2-11eb-06f7-2d5cce4a9f73
begin
	steps::Int64 = 6400
	plots::Int64 = 200
	sstep::Int64 = steps÷plots
	
	ball = Ball(θ=deg2rad(α))
	x = Array{Float64, 1}(undef, plots)
	y = Array{Float64, 1}(undef, plots)
	jplot::Int64 = 1
	for i ∈ 1:steps
		step!(ball)
		if i%sstep == 1
			x[jplot] = ball.x
			y[jplot] = ball.y
			jplot += 1
		end
	end
end

# ╔═╡ c87d5f80-59e3-11eb-2fb2-dbaca4ee07f0
plot(x, y, lw=5, color=:green, ylim=(0, 50), xlim=(0, 100),
	title="Initial Launch at α=$(α)°", xlabel="Distance [m]", ylabel="Height [m]",
	label="Distance traveled before landing: $(round(ball.distance, digits=2)) meters")

# ╔═╡ Cell order:
# ╟─2e943e40-59d7-11eb-1b9c-b5ec5d9cf114
# ╟─ae334720-59de-11eb-2bb5-81773ca0f2e4
# ╟─40e2d3e0-59d7-11eb-0a7b-9f108787b759
# ╠═89eaa350-59c4-11eb-0187-c5ad24105f84
# ╟─84ce10ae-59d7-11eb-0159-d940a49ea8f3
# ╠═ccf7c2e0-59c9-11eb-2c30-05b6926c7125
# ╟─9695ea20-59d7-11eb-0295-73f37d0a1922
# ╠═c876563e-59c5-11eb-0960-fd0d317f137e
# ╟─049cdc20-59df-11eb-0219-0194a1d3ce10
# ╠═fd3d4910-59ca-11eb-0533-abe0fa401cc1
# ╟─c5404f30-59de-11eb-1ea5-d5e0a3378e35
# ╠═5719ba80-59c7-11eb-09d7-0b79c4fe0b8f
# ╟─e8675532-59de-11eb-20be-a94a386bfd21
# ╠═c65c4ee2-59d0-11eb-01cd-af3ec58fd3b8
# ╟─2d96f8e0-59df-11eb-118b-a7b8e259d543
# ╠═25419320-59d6-11eb-2d88-19eb6787edbf
# ╟─51237770-59df-11eb-312f-79544f3b168a
# ╠═55c72500-59d6-11eb-1274-8b6dfb43cfb9
# ╠═eca1d520-59df-11eb-2dc4-d9d2779b6bc3
# ╠═2863fd40-59e0-11eb-16b5-991137d7867e
# ╠═1779f3f0-59d0-11eb-0b0d-2503afafab7d
# ╠═a34de050-59d8-11eb-0125-553fbef90785
# ╟─698b9b50-59e2-11eb-2686-13b813de6970
# ╟─6b0f3142-59e6-11eb-3450-b30c9151ff64
# ╟─74e99c40-59e2-11eb-3ae6-6d9363a2834a
# ╟─1d761150-59e2-11eb-00b4-3b97e23069eb
# ╟─9addf310-59e2-11eb-06f7-2d5cce4a9f73
# ╠═c87d5f80-59e3-11eb-2fb2-dbaca4ee07f0
