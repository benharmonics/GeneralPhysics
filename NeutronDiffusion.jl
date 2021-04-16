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

# ╔═╡ 1addcc10-5304-11eb-06d7-e1c69bd44c54
using Plots 	# plotting backend, takes a sec for first compile

# ╔═╡ 54f41f50-530c-11eb-1a8e-0b08dda08164
html"<h1>Neutron Diffusion</h1>"

# ╔═╡ 7d8eb0c0-5329-11eb-0741-dfb9627d9ea9
html"<i>Note:</i> the plotting backend, Plots.jl, takes a sec to compile; it's normal to take >30 seconds on first compile! 😳 Be patient! It's good!"

# ╔═╡ 69894990-530c-11eb-225c-312d8636850a
html"<h4>First N, the number of grid points:</h4>"

# ╔═╡ dc83a9b0-52b0-11eb-26f5-0d90caf487e5
@bind N html"<input type='range' min='20' max='200' step='10' value='100'>"

# ╔═╡ 76919200-52b2-11eb-3da1-6b26f1a52ec5
N

# ╔═╡ 7e14fdee-530c-11eb-2b26-c390d4d1997a
html"<h4>τ, the time step for our discretized equation:</h4>"

# ╔═╡ 86734650-52b2-11eb-34ef-e926ddb83096
@bind τ html"<input type='range' min='0.000000000001' max='0.0000000006' step='0.000000000005' value='0.0000000001'>"

# ╔═╡ 89a94400-52b2-11eb-1354-2da5b990bc13
τ

# ╔═╡ 9a0fece0-530c-11eb-15bd-29ebb4adb032
html"<h4>Constants:</h4>"

# ╔═╡ b08dc730-52b2-11eb-1fc9-2d30b44c56a0
begin
# Diffusion constant, D, and creation rate, C, for U-235
D = 10^5 	# m²/s
C = 10^8 	# 1/s
L = 1.0  	# m (length of our 1D space)
h = L/(N-1) # grid spacing
end

# ╔═╡ b539f410-5308-11eb-16eb-5354e7f4bae2
html"<h4>Check stability of FTCS algorithm</h4>"

# ╔═╡ 1003abb0-5305-11eb-2ac3-775355caece9
τ <= h^2/(2D)

# ╔═╡ 115a22b0-52ff-11eb-288b-f1f22602c21b
html"<h4>The reaction will grow exponentially if the critical length, <code>L<sub>c</sub></code>, is less than the length of our 1D geometry.</h4>"

# ╔═╡ fcf86f10-52ff-11eb-30b7-bb29ca63f98d
(L_c = π*√(D/C)) < L

# ╔═╡ 65f6b782-530d-11eb-1105-c1ede0ba670a
html"<h4>Finally we set up & execute our main FTCS algorithm:</h4>"

# ╔═╡ d7270d13-212f-42ca-8a9e-a914b5b6dbd1
html"This function will advance state of the neutron density array using a Forward in Time, Centered in Space algorithm (basically averaging neighboring points to solve the diffusion equation):"

# ╔═╡ 895801fb-e8ca-4290-9cb2-e0b0ee59a265
function step!(n)
	# Boundary Conditions are n[1] = n[end] = 0
	n[2:end-1] = n[2:end-1] .+ 
		( D*τ/h^2 ) * ( n[3:end] .+ n[1:end-2] .- 2n[2:end-1] ) .+ 
		C*τ*n[2:end-1]
end

# ╔═╡ 446c3d60-52b3-11eb-3f7a-777fb650bbde
begin
maxsteps::Int64 = 300
maxplots::Int64 = 50
plotstep::Int64 = maxsteps ÷ maxplots
end

# ╔═╡ 35da6fc0-5302-11eb-1a76-050089f82a58
begin
ρₙ = zeros(N) 	# initialize neutron density=0 everywhere
ρₙ[N÷2] = 1/h 	# IC is a delta spike in the middle
# Arrays which will contain data used for plotting later:
xplot = -L/2:h:L/2
nplot = zeros(N, maxplots)
tplot = zeros(maxplots)
iplot = 1 		# index used in loop below
for i ∈ 1:maxsteps
	step!(ρₙ)
	if i%plotstep == 1 	# plotting occasionally
		nplot[:, iplot] = copy(ρₙ)
		tplot[iplot] = i*τ
		iplot += 1
	end
end
end

# ╔═╡ 373273c0-5304-11eb-2ecf-5d731708e057
contourf(tplot, xplot, nplot, title="Neutron Diffusion",
		 xlabel="Time", ylabel="Position", c=:thermal)

# ╔═╡ fc5f0250-530c-11eb-15d9-bb6c5204bde9
surface(tplot, xplot, nplot, c=:thermal, title="Neutron Diffusion",
	    xlabel="Time", ylabel="Position", zlabel="Neutron Density", yticks=[])

# ╔═╡ aa5c5bd0-530a-11eb-3b31-298cca0ffbf1
@gif for i ∈ 1:maxplots
	plot(xplot, nplot[:, i], lw=3, legend=false, ylims=(0, nplot[N÷2, end]),
	     title="Neutron Diffusion Over $(τ*maxsteps) Seconds", 
		 xlabel="Position", ylabel="Neutron Density")
end

# ╔═╡ Cell order:
# ╟─54f41f50-530c-11eb-1a8e-0b08dda08164
# ╟─7d8eb0c0-5329-11eb-0741-dfb9627d9ea9
# ╟─69894990-530c-11eb-225c-312d8636850a
# ╟─dc83a9b0-52b0-11eb-26f5-0d90caf487e5
# ╠═76919200-52b2-11eb-3da1-6b26f1a52ec5
# ╟─7e14fdee-530c-11eb-2b26-c390d4d1997a
# ╟─86734650-52b2-11eb-34ef-e926ddb83096
# ╠═89a94400-52b2-11eb-1354-2da5b990bc13
# ╟─9a0fece0-530c-11eb-15bd-29ebb4adb032
# ╠═b08dc730-52b2-11eb-1fc9-2d30b44c56a0
# ╟─b539f410-5308-11eb-16eb-5354e7f4bae2
# ╠═1003abb0-5305-11eb-2ac3-775355caece9
# ╟─115a22b0-52ff-11eb-288b-f1f22602c21b
# ╠═fcf86f10-52ff-11eb-30b7-bb29ca63f98d
# ╟─65f6b782-530d-11eb-1105-c1ede0ba670a
# ╟─d7270d13-212f-42ca-8a9e-a914b5b6dbd1
# ╠═895801fb-e8ca-4290-9cb2-e0b0ee59a265
# ╠═446c3d60-52b3-11eb-3f7a-777fb650bbde
# ╠═35da6fc0-5302-11eb-1a76-050089f82a58
# ╠═1addcc10-5304-11eb-06d7-e1c69bd44c54
# ╠═373273c0-5304-11eb-2ecf-5d731708e057
# ╠═fc5f0250-530c-11eb-15d9-bb6c5204bde9
# ╠═aa5c5bd0-530a-11eb-3b31-298cca0ffbf1
