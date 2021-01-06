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

# ╔═╡ 77c27e30-4e4f-11eb-2226-171fe06883f6
using Plots 	# plotting backend

# ╔═╡ 5d590080-4e56-11eb-3057-35a732f909a5
html"<h1>The Diffusion Equation</h1><h5>Solving the diffusion equation with Forward in Time, Centered in Space (FTCS) method</h5>"

# ╔═╡ 164fe1e0-4e56-11eb-03e8-a7fd1cfd0cbf
html"<h2>First, n, the number of grid points:</h2>"

# ╔═╡ e6d91a30-4e50-11eb-1a52-2d70bda223a8
@bind n html"<input type='range' min='40' max='250' value='100' step='10'>"

# ╔═╡ 549fac00-4e51-11eb-219d-0bcbad1c60bc
n, typeof(n)

# ╔═╡ 3cd57c30-4e56-11eb-3f82-1925b376e380
html"<h2>Now τ, the time step:</h2>"

# ╔═╡ 7e865630-4e52-11eb-1f97-2f9e4442472e
@bind τ html"<input type='range' min='0.000001' max='0.0001' step='0.000005' value='.00001'>"

# ╔═╡ 3b917ff0-4e55-11eb-33c7-ebf29e1dd716
τ, typeof(τ) 	# seconds

# ╔═╡ 93eeed50-4e63-11eb-2baa-f5ad3c0aebaf
html"<h2>Other Constants</h2>"

# ╔═╡ 2c501530-4e53-11eb-1e54-5bd251d5eb4a
begin
	L::Float64 = 1.0 		# rod length
	h::Float64 = L/(n-1)	# grid size
	κ::Float64 = 1.0 		# diffusion coefficient
	C::Float64 = κ*τ/h^2 	# solution expected to be stable for C <= 0.5
end

# ╔═╡ 2fbfd7d0-4e64-11eb-3760-bbbe56c86726
html"<h5><i>This constant C is important!</i><br>Make sure it's <= 0.5 or you will have some problems later.</h5>"

# ╔═╡ 83fcc8d2-4e64-11eb-3bc5-1b033c034ab4
C # C ∝ τ and C ∝ n², so adjust your sliders accordingly

# ╔═╡ 376c8600-4e63-11eb-0f8b-21639036a164
html"<h2>Boundary and Initial Conditions</h2><p>The default boundary conditions we will use are T[1] = T[n] = 0 (heat sink at boundary). The default initial condition is a delta spike in the middle of the rod, T=0 everywhere else.</p>"

# ╔═╡ ce7218b0-4e56-11eb-1fa8-a3cf768be7cf
begin
	T = zeros(Float64, n)			# initialize temperature to zero everywhere
	T[floor(Int8, n/2)] = 1.0/h 	# set delta spike in center of rod
	xplot::Array{Float64, 1} = (0.0:n-1)*h .- L/2 	# record x pos of all grid points
	iplot::Int64 = 1 				# counter used to count plots
	maxsteps::Int64 = 300 			# maximum number of iterations
	maxplots::Int64 = 50 			# number of snapshots to take
	plotstep::Float64 = maxsteps/maxplots 	# number of time steps between snapshots
end

# ╔═╡ 16ec2e9e-4e66-11eb-2f4b-453bf7b08cf8
html"<h2>Finally, the main step algorithm, FTCS:</h2>"

# ╔═╡ f58d8300-4e59-11eb-31b1-0562ea25b172
begin
	Tplot = Array{Float64, 2}(undef, n, maxplots) # temperature, empty array
	timeplot = Array{Float64, 1}(undef, maxplots) # time, empty array
	for i ∈ 1:maxsteps #* MAIN STEP FUNCTION
		T[2:n-1] = T[2:n-1] .+ C*( T[3:n] .+ T[1:n-2] .- 2T[2:n-1] )	# FTCS
		# record temperature for plotting occasionally
		if i % plotstep == 0
			Tplot[:, iplot] = copy(T)
			timeplot[iplot] = i*τ
			iplot += 1
		end
	end
end

# ╔═╡ 576758b0-4e6b-11eb-0164-53771aa2dabd
html"<h2>Plotting</h2>"

# ╔═╡ 48596260-4e5b-11eb-1006-9703ff582c06
contourf(timeplot, xplot, Tplot, title="Temperature Diffusion", 
		 xlabel="Time", ylabel="Position", c=:thermal)

# ╔═╡ 1d3e2010-4e6b-11eb-32bc-1785268babdf
surface(timeplot, xplot, Tplot, 
		xlabel="Time", ylabel="Position", zlabel="Temp", c=:thermal)

# ╔═╡ fb534f20-4e60-11eb-2300-25afc19ec21b
@gif for i ∈ 1:maxplots
	plot(xplot, Tplot[:, i], ylims=(0, Tplot[floor(Int8, n/2), 3]), 
		 lw=3, legend=false, title="Diffusion Over $(τ*maxsteps) Seconds", 
		 xlabel="Position", ylabel="Temperature")
end

# ╔═╡ Cell order:
# ╟─5d590080-4e56-11eb-3057-35a732f909a5
# ╟─164fe1e0-4e56-11eb-03e8-a7fd1cfd0cbf
# ╟─e6d91a30-4e50-11eb-1a52-2d70bda223a8
# ╠═549fac00-4e51-11eb-219d-0bcbad1c60bc
# ╟─3cd57c30-4e56-11eb-3f82-1925b376e380
# ╟─7e865630-4e52-11eb-1f97-2f9e4442472e
# ╠═3b917ff0-4e55-11eb-33c7-ebf29e1dd716
# ╟─93eeed50-4e63-11eb-2baa-f5ad3c0aebaf
# ╠═2c501530-4e53-11eb-1e54-5bd251d5eb4a
# ╟─2fbfd7d0-4e64-11eb-3760-bbbe56c86726
# ╠═83fcc8d2-4e64-11eb-3bc5-1b033c034ab4
# ╟─376c8600-4e63-11eb-0f8b-21639036a164
# ╠═ce7218b0-4e56-11eb-1fa8-a3cf768be7cf
# ╟─16ec2e9e-4e66-11eb-2f4b-453bf7b08cf8
# ╠═f58d8300-4e59-11eb-31b1-0562ea25b172
# ╟─576758b0-4e6b-11eb-0164-53771aa2dabd
# ╠═77c27e30-4e4f-11eb-2226-171fe06883f6
# ╠═48596260-4e5b-11eb-1006-9703ff582c06
# ╠═1d3e2010-4e6b-11eb-32bc-1785268babdf
# ╠═fb534f20-4e60-11eb-2300-25afc19ec21b
