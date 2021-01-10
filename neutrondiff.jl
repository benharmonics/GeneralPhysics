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

# ╔═╡ 1addcc10-5304-11eb-06d7-e1c69bd44c54
using Plots 	# plotting backend, takes a sec for first compile

# ╔═╡ 54f41f50-530c-11eb-1a8e-0b08dda08164
html"<h1>Neutron Diffusion</h1>"

# ╔═╡ 69894990-530c-11eb-225c-312d8636850a
html"<h4>First N, the number of grid points:</h4>"

# ╔═╡ dc83a9b0-52b0-11eb-26f5-0d90caf487e5
@bind N html"<input type='range' min='20' max='200' step='10' value='80'>"

# ╔═╡ 76919200-52b2-11eb-3da1-6b26f1a52ec5
N, typeof(N)

# ╔═╡ 7e14fdee-530c-11eb-2b26-c390d4d1997a
html"<h4>τ, the time step for our discretized equation:</h4>"

# ╔═╡ 86734650-52b2-11eb-34ef-e926ddb83096
@bind τ html"<input type='range' min='0.000000000001' max='0.000000001' step='0.000000000005' value='0.0000000001'>"

# ╔═╡ 89a94400-52b2-11eb-1354-2da5b990bc13
τ, typeof(τ)

# ╔═╡ 9a0fece0-530c-11eb-15bd-29ebb4adb032
html"<h4>Constants:</h4>"

# ╔═╡ b08dc730-52b2-11eb-1fc9-2d30b44c56a0
begin
	# Diffusion constant, D, and Creation rate, C, for U-235
	D::Float64 = 10^5 # m²/2
	C::Float64 = 10^8 # 1/s
	L::Float64 = 1.0  # length of the bar
	h::Float64 = L/(N-1) # grid spacing
end

# ╔═╡ b539f410-5308-11eb-16eb-5354e7f4bae2
html"<h4>Check stability of FTCS algorithm</h4>"

# ╔═╡ 1003abb0-5305-11eb-2ac3-775355caece9
τ <= h^2/(2D), D*τ/h^2 <= 0.5 # equivalent statements

# ╔═╡ 115a22b0-52ff-11eb-288b-f1f22602c21b
html"<h4>The reaction will grow exponentially if the critical length, L_c, is less than the length of our 1D geometry.</h4>"

# ╔═╡ fcf86f10-52ff-11eb-30b7-bb29ca63f98d
L_c = π*√(D/C)

# ╔═╡ 6816eb50-5300-11eb-3800-8fa45133830b
L > L_c 	# returns true if the reaction is supercritical

# ╔═╡ 65f6b782-530d-11eb-1105-c1ede0ba670a
html"<h4>Finally we set up & execute our main FTCS algorithm:</h4>"

# ╔═╡ 446c3d60-52b3-11eb-3f7a-777fb650bbde
begin
	n = zeros(Float64, N) 	# initialize zeros everywhere
	n[N÷2] = 1/h 			# IC is a delta spike in the middle
	xplot::Array{Float64, 1} = (0.0:h:L) .- L/2
	maxsteps::Int64 = 300
	maxplots::Int64 = 50
	plotstep::Int64 = maxsteps ÷ maxplots
end

# ╔═╡ 35da6fc0-5302-11eb-1a76-050089f82a58
begin
	nplot = Array{Float64, 2}(undef, N, maxplots)
	tplot = Array{Float64, 1}(undef, maxplots)
	iplot::Int64 = 1
	for i ∈ 1:maxsteps # MAIN ALGORITHM
		n[2:N-1] = (1 + C*τ)*n[2:N-1] .+ (D*τ/h^2)*(n[3:N] .+ n[1:N-2] .- 2n[2:N-1])
		if i%plotstep == 0
			nplot[:, iplot] = copy(n)
			tplot[iplot] = i*τ
			iplot += 1
		end
	end
end

# ╔═╡ 373273c0-5304-11eb-2ecf-5d731708e057
contourf(tplot, xplot, nplot, title="Neutron Diffusion",
		 xlabel="time", ylabel="position", c=:thermal)

# ╔═╡ fc5f0250-530c-11eb-15d9-bb6c5204bde9
surface(tplot, xplot, nplot, c=:thermal, title="Neutron Diffusion",
	    xlabel="Time", ylabel="Position", zlabel="Neutron Density")

# ╔═╡ aa5c5bd0-530a-11eb-3b31-298cca0ffbf1
@gif for i ∈ 1:maxplots
	plot(xplot, nplot[:, i], lw=3, legend=false, ylims=(0, nplot[N÷2, end]),
	     title="Neutron Diffusion", xlabel="Position", ylabel="Neutron Density")
end

# ╔═╡ Cell order:
# ╟─54f41f50-530c-11eb-1a8e-0b08dda08164
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
# ╠═6816eb50-5300-11eb-3800-8fa45133830b
# ╟─65f6b782-530d-11eb-1105-c1ede0ba670a
# ╠═446c3d60-52b3-11eb-3f7a-777fb650bbde
# ╠═35da6fc0-5302-11eb-1a76-050089f82a58
# ╠═1addcc10-5304-11eb-06d7-e1c69bd44c54
# ╠═373273c0-5304-11eb-2ecf-5d731708e057
# ╠═fc5f0250-530c-11eb-15d9-bb6c5204bde9
# ╠═aa5c5bd0-530a-11eb-3b31-298cca0ffbf1
