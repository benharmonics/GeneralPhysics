### A Pluto.jl notebook ###
# v0.14.1

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

# ╔═╡ c743b90b-6514-428f-9db9-84b5e4c91ac2
using Plots

# ╔═╡ faf67a36-cc26-4d26-bccb-6a7021fa57a9
html"<h1>Advection - the Heat Equation</h1>
First set N, the number of grid points:"

# ╔═╡ 7da260be-9ceb-11eb-1752-d7a413e34a8b
@bind N html"<input type='range' min='20' max='100' step='5' value='50'>"

# ╔═╡ b92aa438-05d0-4e8c-9e53-e337ffa56616
N

# ╔═╡ 16ee3ed7-fd6d-47b0-a16a-b60fe59256a6
html"Now τ, the time step (set first in ms then divided by 1000):"

# ╔═╡ c956df96-ab01-4e9d-9f93-154e718f7f1f
@bind ms html"<input type='range' min='2' max='20' step='1' value='10'>"

# ╔═╡ d5395ca5-747f-43b0-a815-590e9b407e4b
τ = ms/1000 # seconds

# ╔═╡ c1845d77-3edf-4026-a38f-99263878846b
html"Basic characteristics of the system:"

# ╔═╡ 1ac04409-845e-46e1-bbdb-6fc43e033df5
begin
L = 1.0 							# Size (length) of system
h = L/N 							# Grid spacing
x = -L/2:h:L/2						# Coordinates of grid points
c = 1.0 							# Wave speed
end

# ╔═╡ aba2b1ea-2789-41ef-8566-c92525ee2bb5
html"Setting up periodic boundary conditions:"

# ╔═╡ 19e4e286-141e-41d2-9e67-9818bf1c6ad1
begin
iₚ = cat(2:length(x), 1, dims=1) 				# offset indices in + direction
iₘ = cat(length(x), 1:(length(x)-1), dims=1) 	# offset in - direction
end

# ╔═╡ ce1f8f8a-9c9f-4c5f-8a6d-8eb730102153
html"Step function to perform one differential operation in-place:"

# ╔═╡ b4c6c1f4-1c2b-48ac-b0c4-ec4f5f8ba180
function advectstep!(v::AbstractVector, Δt::Float64=τ; method="lw")
	""" PARAMETERS:
	positional
		v  -> vector to step
		Δt -> time step
		N  -> number of grid points
	keyword
		method -> numerical method to use in step
	"""
	κ::Float64 = -c*Δt/2h
	κ_lw::Float64 = 2κ^2
	# Numerical methods:
	if method == "ftcs" 	# Forward in Time, Centered in Space
		v .= v .+ κ*(v[iₚ] .- v[iₘ])
	elseif method == "lax"  # Lax
		v .= .5*(v[iₚ] .+ v[iₘ]) .+ κ*(v[iₚ] .- v[iₘ])
	elseif method == "lw" 	# Lax-Wendorff
		v .= v .+ κ*(v[iₚ] .- v[iₘ]) .+ κ_lw*(v[iₚ] .+ v[iₘ] .- 2v)
	end
end

# ╔═╡ eed1bd3c-b528-4d2b-8abc-18706ba16f6f
html"Initializing system with a gaussian wavepacket, then plotting:"

# ╔═╡ a49a051a-c2bc-4764-aaea-2843b5db5fc9
begin
σ = 0.1 							# Width of the Gaussian plane
k = π/σ 							# Wave number
a = [cos(k*xᵢ) + ℯ^(-xᵢ^2 / 2σ^2) for xᵢ in x] 	# Initial Condition -> Gaussian
lims = (minimum(a), maximum(a)) 	# ylims for plotting
end

# ╔═╡ 482f0403-aaee-45b4-8183-aa78a8d19b3f
html"A helper function:"

# ╔═╡ 8e8ab513-eba0-45b4-98da-03429066afaf
function reset!(α::Vector)
	α[:] = [cos(k*xᵢ) + ℯ^(-xᵢ^2 / 2σ^2) for xᵢ in x]
end

# ╔═╡ fe1c07ae-700c-41d7-b54f-2b8ee3ea6006
@gif for i ∈ 1:500
	i == 1 && reset!(a)
	advectstep!(a; method="lax")
	plot(x, a, label="t=$(round(τ*i, digits=3)) s", lw=2, ylims=lims,
		title = "Advection of a Wave Packet", xlabel="x", ylabel="T")
end every 6

# ╔═╡ abb2a9f6-a503-4cf2-8e60-51ba1f33872e
html"Maybe we want to visualize this in 3d with time as one axis:"

# ╔═╡ eda18287-b390-48d4-a90c-90101132e8f5
let
a = [cos(k*xᵢ) + ℯ^(-xᵢ^2 / 2σ^2) for xᵢ in x]
# Setting up empty arrays which will be used for plotting
nplots = 100
aplot = zeros(length(x), nplots)
tplot = zeros(nplots)
maxstep = 800
plotstep = maxstep ÷ nplots # -> integer
iplot = 1
for i ∈ 1:maxstep
	if i%plotstep == 1
		aplot[:, iplot] = copy(a)
		tplot[iplot] = i*τ
		iplot += 1
	end
	advectstep!(a; method="lax")
end
surface(tplot, x, aplot, xlabel="Time (s)", ylabel="Position", zlabel="Temperature")
title!("Advection of a Gaussian Wave Packet")
end

# ╔═╡ Cell order:
# ╟─faf67a36-cc26-4d26-bccb-6a7021fa57a9
# ╟─7da260be-9ceb-11eb-1752-d7a413e34a8b
# ╠═b92aa438-05d0-4e8c-9e53-e337ffa56616
# ╟─16ee3ed7-fd6d-47b0-a16a-b60fe59256a6
# ╟─c956df96-ab01-4e9d-9f93-154e718f7f1f
# ╠═d5395ca5-747f-43b0-a815-590e9b407e4b
# ╟─c1845d77-3edf-4026-a38f-99263878846b
# ╠═1ac04409-845e-46e1-bbdb-6fc43e033df5
# ╟─aba2b1ea-2789-41ef-8566-c92525ee2bb5
# ╠═19e4e286-141e-41d2-9e67-9818bf1c6ad1
# ╟─ce1f8f8a-9c9f-4c5f-8a6d-8eb730102153
# ╠═b4c6c1f4-1c2b-48ac-b0c4-ec4f5f8ba180
# ╠═c743b90b-6514-428f-9db9-84b5e4c91ac2
# ╟─eed1bd3c-b528-4d2b-8abc-18706ba16f6f
# ╠═a49a051a-c2bc-4764-aaea-2843b5db5fc9
# ╟─482f0403-aaee-45b4-8183-aa78a8d19b3f
# ╠═8e8ab513-eba0-45b4-98da-03429066afaf
# ╠═fe1c07ae-700c-41d7-b54f-2b8ee3ea6006
# ╟─abb2a9f6-a503-4cf2-8e60-51ba1f33872e
# ╠═eda18287-b390-48d4-a90c-90101132e8f5
