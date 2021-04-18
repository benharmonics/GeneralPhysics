### A Pluto.jl notebook ###
# v0.14.2

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

# ╔═╡ 786a23ad-ee13-4299-b58f-b4bc2cff50f7
using Plots

# ╔═╡ f84ba617-f84e-4072-94a1-9d85fd6e2ef0
html"<h1>Laplace.jl</h1>
<h4>Solving the Laplace Equation using Jacobi, Gauss-Seidel, and Simultaneous Over Relaxation methods on a square grid</h4>
<hr>
<h4>First, set N, the number of grid points on a side:</h4>"

# ╔═╡ 7cea9966-828e-48b1-aa2d-7f3fcb21cadc
@bind N html"<input type='range' min='3' max='30' step='1' value='20'>"

# ╔═╡ 8b743ed0-ac8e-4135-8461-ad0ce14da8db
N

# ╔═╡ 34e94d32-6b28-4cf7-bc22-20f9cfd0d346
html"<h4>Setting up the grid</h4>"

# ╔═╡ cd6f8f6c-1e4c-4eb4-b7ae-be1c62e5f3ad
begin
L = 1 				# Size of system (length of side normalized to be 1)
h = L/(N-1) 		# grid spacing
x = y = -L/2:h:L/2 	# x and y locations
end

# ╔═╡ 084cd4d2-2e7f-4700-862e-c88f311dc633
begin
ϕ = zeros(N, N) 	# Matrix potential
ϕ₀ = 1 				# Potential at y = L
end

# ╔═╡ 09a56e33-ef32-45de-822e-299a8b209180
html"<h4>Resetting functions</h4>
<br>The <b>Initial Condition</b> is defined as:"

# ╔═╡ db7f9c67-0c89-4b63-86de-aa7a7da608c0
function reset!(ψ::Array, ψ₀::Real = ϕ₀, n::Integer = N)
	for i ∈ 1:n, j ∈ 1:n
		ψ[i, j] = ψ₀ * ( 4/(π*sinh(π)) ) * sin(π*x[i]/L) * sinh(π*y[j]/L)
	end
end

# ╔═╡ 98412958-f1d0-4ee3-8439-815c982d9e5d
html"<b>Boundary Conditions:</b> ϕ = ϕ₀ along the rightmost column, 0 along the other sides:"

# ╔═╡ 10913cfe-fbb1-432e-bc34-a22dfe3602fe
function setboundaryconditions!(ψ::Array, ψ₀::Real = ϕ₀)
	ψ[1, :] .= ψ[end, :] .= ψ[:, 1] .= 0
	ψ[:, end] .= fill(ψ₀, size(ψ, 1))
end

# ╔═╡ 0955e4b8-19e7-49e5-bdcf-187996e337c5
html"<h4>Step functions</h4>
<br>
<b>Jacobi Method<b>"

# ╔═╡ 31a399e8-fb24-4210-b0a7-58a9a6192abe
function jacobistep!(ψ::Array, changesum::Real, n::Integer = N)
	ψₙ = copy(ψ)
	for i ∈ 2:(n-1), j ∈ 2:(n-1)
		ψₙ[i, j] = .25*(ψ[i+1, j] + ψ[i-1, j] + ψ[i, j+1] + ψ[i, j-1])
		changesum += abs(1 - ψ[i, j]/ψₙ[i, j])
	end
	ψ[:, :] = ψₙ[:, :]
end

# ╔═╡ 35eefeef-7d13-4e4e-9656-0e72214ef7ef
html"<b>Gauss-Seidel Method</b>"

# ╔═╡ f214b84c-4fdb-4567-904e-4df485dca12b
function gs_step!(ψ::Array, changesum::Real, n::Integer = N)
	for i ∈ 2:(n-1), j ∈ 2:(n-1)
		newval = .25*(ψ[i+1, j] + ψ[i-1, j] + ψ[i, j+1] + ψ[i, j-1])
		changesum += abs(1 - ψ[i, j]/newval)
		ψ[i, j] = newval
	end
end

# ╔═╡ b01bef7f-c9c3-4e38-9aef-c7e727739bb8
html"<b>Simultaneous Over-Relaxation Method</b>"

# ╔═╡ 927e449c-699e-40d6-ad93-d4da9a77a392
Ω₀ = 2 / (1+sin(π/N)) 	# optimizes convergence time for SOR method

# ╔═╡ 1eb90fd0-6be6-4cbe-b513-ed8eb9bc81a1
function sorstep!(ψ::Array, changesum::Real, n::Integer = N, Ω::Real = Ω₀)
	for i ∈ 2:(n-1), j ∈ 2:(n-1)
		newval = .25Ω * (ψ[i+1, j] + ψ[i-1, j] + ψ[i, j+1] + ψ[i, j-1]) + 
			(1 - Ω) * ψ[i, j]
		changesum += abs(1 - ψ[i, j]/newval)
		ψ[i, j] = newval
	end
end

# ╔═╡ 6b360f13-ec44-4a9e-a064-38eaadb13c0e
html"<h4>Other preparations</h4>
<br>
Maximum number of steps (so we don't just loop forever):"

# ╔═╡ 667382b6-c6aa-4655-bec5-9c00f3b7b463
imax = N^2

# ╔═╡ 10bdbf0f-32c7-4df3-869a-56d266f56fac
html"Iteration ceases once the average correction is < 10<sup>-4</sup>:"

# ╔═╡ ce3419a8-3984-488e-85e9-0d0786bbae2d
changedesired = 10^-4

# ╔═╡ 1d13f124-1d16-4374-81c5-4ef8a0c8cfa8
html"<h4>Plotting</h4>"

# ╔═╡ 08463463-a613-45dc-8bf6-8ba2569d9764
let
reset!(ϕ)
setboundaryconditions!(ϕ)
for _ ∈ 1:imax
	changesum = 0 		# Total change in system this iteration
	jacobistep!(ϕ, changesum) 	# Then take the average change per (N-2)^2 points:
	changesum/(N-2)^2 < changedesired && continue
end
surface(x, y, rotr90(ϕ), title="Jacobi Method", xticks=[], yticks=[],
		xlabel="x", ylabel="y")
end

# ╔═╡ e425201e-acb5-4975-bc70-47d80fc5686e
let
reset!(ϕ)
setboundaryconditions!(ϕ)
for _ ∈ 1:imax
	changesum = 0
	gs_step!(ϕ, changesum)
	changesum/(N-2)^2 < changedesired && continue
end
surface(x, y, rotr90(ϕ), title="Gauss-Seidel Method", xticks=[], yticks=[],
		xlabel="x", ylabel="y")
end

# ╔═╡ ee21c706-b9f3-43ba-8c28-ea152ef4a9bb
let
reset!(ϕ)
setboundaryconditions!(ϕ)
for _ ∈ 1:imax
	changesum = 0
	sorstep!(ϕ, changesum)
	changesum/(N-2)^2 < changedesired && continue
end
surface(x, y, rotr90(ϕ), title="Simultaneous Over-Relaxation Method",
		xticks=[], yticks=[], xlabel="x", ylabel="y")
end

# ╔═╡ Cell order:
# ╟─f84ba617-f84e-4072-94a1-9d85fd6e2ef0
# ╟─7cea9966-828e-48b1-aa2d-7f3fcb21cadc
# ╠═8b743ed0-ac8e-4135-8461-ad0ce14da8db
# ╟─34e94d32-6b28-4cf7-bc22-20f9cfd0d346
# ╠═cd6f8f6c-1e4c-4eb4-b7ae-be1c62e5f3ad
# ╠═084cd4d2-2e7f-4700-862e-c88f311dc633
# ╟─09a56e33-ef32-45de-822e-299a8b209180
# ╠═db7f9c67-0c89-4b63-86de-aa7a7da608c0
# ╟─98412958-f1d0-4ee3-8439-815c982d9e5d
# ╠═10913cfe-fbb1-432e-bc34-a22dfe3602fe
# ╟─0955e4b8-19e7-49e5-bdcf-187996e337c5
# ╠═31a399e8-fb24-4210-b0a7-58a9a6192abe
# ╟─35eefeef-7d13-4e4e-9656-0e72214ef7ef
# ╠═f214b84c-4fdb-4567-904e-4df485dca12b
# ╟─b01bef7f-c9c3-4e38-9aef-c7e727739bb8
# ╠═927e449c-699e-40d6-ad93-d4da9a77a392
# ╠═1eb90fd0-6be6-4cbe-b513-ed8eb9bc81a1
# ╟─6b360f13-ec44-4a9e-a064-38eaadb13c0e
# ╠═667382b6-c6aa-4655-bec5-9c00f3b7b463
# ╟─10bdbf0f-32c7-4df3-869a-56d266f56fac
# ╠═ce3419a8-3984-488e-85e9-0d0786bbae2d
# ╟─1d13f124-1d16-4374-81c5-4ef8a0c8cfa8
# ╠═786a23ad-ee13-4299-b58f-b4bc2cff50f7
# ╠═08463463-a613-45dc-8bf6-8ba2569d9764
# ╠═e425201e-acb5-4975-bc70-47d80fc5686e
# ╠═ee21c706-b9f3-43ba-8c28-ea152ef4a9bb
