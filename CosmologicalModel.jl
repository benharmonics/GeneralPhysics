### A Pluto.jl notebook ###
# v0.14.3

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

# ╔═╡ 8dbbaab7-c8a8-495a-b34e-2df3ee51be3f
using Plots

# ╔═╡ 44427f8f-4a65-44da-9062-cce6e75e2569
html"<h1>Modeling the Scale Factor</h1>
The acceleration equation is given by<br>"

# ╔═╡ ecd37f62-bc2d-4256-95e9-b29424a246d6
md"``(\frac{ä}{a})² = -\frac{4πG}{3c²} (ϵ(t) + 3P(t)) + \frac{Λ}{3}``"

# ╔═╡ dcdb469e-1ec3-4fec-8bf1-d429719dcd9b
md"
Assume the energy density is dominated by non-relativistic matter, i.e. ``ϵ ≈ ρc²`` and ``P << ϵ``."

# ╔═╡ 2890c2ad-8409-45bf-8fd4-a6cd426ab55d
md"For this case, ``ρ(t) ≈ ρ₀(a(t)=a₀)^{-3}``, where ``a₀ = 1`` is the scale factor of the universe today (when ``t = t₀``)."

# ╔═╡ 316b59fa-ead6-4a1a-ab2f-c2ded137a0f2
md"
The critical density ``ρ_{crit} = \frac{3H₀²}{8πG}``."

# ╔═╡ 9cee1d18-0442-4dae-9e80-de38caa6163c
html"Thus:"

# ╔═╡ 9da1395a-6e7d-4bbe-a76d-5b35e6459b5a
md"``ä(t) = -\frac{ρ₀}{2ρ_{crit}} (\frac{H₀}{a(t)})² + \frac{a(t)Λ}{3}``,"

# ╔═╡ 8a031c70-9d29-44ce-80fb-028c560cb51a
html"or"

# ╔═╡ ba2770bd-33a1-40f8-ae37-9a25a082b4af
md"→ ``\frac{d²}{dy²}a(y) = -\frac{1}{2} Ωₘa(y)^{-2} + Ω_λa(y)``,"

# ╔═╡ ba921154-fce7-4297-8980-eee506b6d653
md"where ``Ωₘ = \frac{ρ₀}{ρ_{crit}}`` and ``Ω_λ = \frac{Λ}{3H₀²}`` and"

# ╔═╡ 0f0a3b82-c424-4c20-ae3f-824514fe01d6
md"``y = H₀t`` ⇛ ``\frac{d²}{dy²} a(y) = \frac{ä}{H₀²}``."

# ╔═╡ 50ff4ea4-8a4f-4179-9fc5-d554d4af4fcc
md"So first, let's create a model for any two given values ``Ωₘ`` and ``Ω_λ``:"

# ╔═╡ 400a2e78-afdb-11eb-2df6-7ff8a8e36528
@Base.kwdef mutable struct CosmoModel
	a  = 1.0
	da = 1.0
	Ωm = 0.3
	Ωλ = 0.7
	y  = 0.0 		
end

# ╔═╡ aae7f619-f21e-486f-88fd-6bb051c3b9a5
md"Recall that, today, ``y=0``, and"

# ╔═╡ eeb191c7-1ed5-4e8b-a408-9c4129166559
md"``a(y=0)=a₀≝1``. In addition, since"

# ╔═╡ ce002252-c4bc-4704-974f-73ff0b7139d7
md"``H₀≝\frac{ȧ}{a}``,"

# ╔═╡ 21e11baa-5239-4f05-83cf-bea77738e765
md"``\frac{da(y=0)}{dy}≝1``."

# ╔═╡ 844805b8-3e6e-496d-bce3-b33c6d26012a
md"Let's create a step function that advances this cosmological model:"

# ╔═╡ 0f9a7e58-73bd-42bd-b77c-3a3e670a5de8
function step!(c::CosmoModel, dy::Real=0.01)
	# Euler's method, what else?
	dda = -0.5*c.Ωm/c.a^2 + c.Ωλ*c.a
	c.da += dda * dy
	c.a += c.da * dy
	c.y += dy 	
end

# ╔═╡ 1ece7af1-2cd6-4937-9e4f-2a064d1dc859
md"We're going to measure ``-2≤y≤2``, so let's prepare the arrays for a and y, where values corresponding to ``y=0`` are going to fall squarely in the middle of the array:"

# ╔═╡ 539643eb-e04d-4515-b416-1e815b73fd77
begin
aplot = zeros(401, 3)
aplot[201, :] = [1.0 1.0 1.0] # Initial Conditions - let's just record immediately
yplot = -2:0.01:2
end

# ╔═╡ e01b33a4-f334-4633-a83c-93f5d67d2da2
html"Backward time integration:"

# ╔═╡ 070c5d93-09fc-42a5-b90b-73ea44cdad40
let
cosmos = [CosmoModel(Ωλ=0), CosmoModel(Ωm=0), CosmoModel()]
for (i, cosmo) ∈ enumerate(cosmos), y ∈ 200:-1:1
	step!(cosmo, -0.01) 	# dy < 0 for backwards integration
	aplot[y, i] = cosmo.a
end
end

# ╔═╡ 74ed32d4-6917-405e-b501-de1521070b53
html"Forward time integration:"

# ╔═╡ c44b31f2-d9e6-433f-a21f-a22ea78f9568
let
cosmos = [CosmoModel(Ωλ=0), CosmoModel(Ωm=0), CosmoModel()]
for (i, cosmo) ∈ enumerate(cosmos), y ∈ 202:401
	step!(cosmo)
	aplot[y, i] = cosmo.a
end
end

# ╔═╡ bff766db-188e-484d-8b53-ebd71d00e120
md"For each model, finding the ``y`` value at which ``a(y)=0`` will determine the estimated age of the universe:"

# ╔═╡ c756b29e-2a4a-4e4c-adce-fc633d3bc21e
izeros = [findfirst(≥(0), aplot[:, i]) for i ∈ 1:3]

# ╔═╡ 729c98bd-18a6-4395-abea-e21d899a9324
yzeros = [yplot[i] for i ∈ izeros]

# ╔═╡ d82029ce-8163-4de2-bdac-6ffa0a867580
let
start = min(izeros...)
y = yplot[start:end]
a = aplot[start:end, :]
plot(y, a[:, 1], lw=2, label="Ωλ=0", legend=:topleft)
plot!(y, a[:, 2], lw=2, label="Ωₘ=0")
plot!(y, a[:, 3], lw=2, label="Benchmark Model")
plot!(ylim=(0,6), xlabel="y", ylabel="a(y)", title="Scale Factor a(y) vs. y")
vline!(yzeros, label="Zeros: y = $(sort(yzeros))", linestyle=:dash)
annotate!(0, 2, "Today, y=0")
end

# ╔═╡ 3e5601e8-88b3-4062-902a-09518b592e4e
html"H<sub>0</sub><math>≈70</math> km/s/Mpc. Converting units to 1/s:"

# ╔═╡ dec2b537-cc4d-4075-a0a0-7e27b25998ca
H₀ = 70 * 3.2407792700054e-20 	# 1 / s

# ╔═╡ ba3010b9-41ee-4532-a7f5-2992c89abb97
html"<code>seconds2years</code> will convert a time in seconds to a time in years:"

# ╔═╡ fdbd0b7e-26ad-45de-b42d-c407e120787b
seconds2years(s::Real) = s / (60*60*24*365)

# ╔═╡ cdefb2ec-7a6d-40a9-90ea-3c1a6bd44904
md"Converting each ``y`` value to **billions of years**:"

# ╔═╡ 1d655ed7-9d23-47bf-a204-84d4eea9e3ea
bya = seconds2years.([abs(y)/H₀ for y ∈ yzeros]) * 10^-9

# ╔═╡ c459cb1e-0a34-4b6e-b41d-b4da1ad02c33
("Ωₘ=0:", bya[1]), ("Ωλ=0:", bya[2]), ("Benchmark:", bya[3])

# ╔═╡ c0af49f7-f4c2-4ac3-b9b1-157dd0dd1ca6
md"What about models which do not expand forever?"

# ╔═╡ 998cf5a1-6888-4233-9310-6d4cc8c89537
md"Let's create a function that just forward-integrates our cosmological model:"

# ╔═╡ 5f785097-5fe2-436a-98b6-d8aaf4e1a607
function runsimulation(c::CosmoModel, maxsteps::Int=10_000)
	y = [c.y]; a = [c.a]
	for _ ∈ 1:maxsteps
		step!(c)
		c.a ≤ 0 && continue
		push!(y, c.y); push!(a, c.a)
	end
	y, a
end

# ╔═╡ 4b8b8af4-2940-40c9-be7b-2743c85b79ac
let
cosmo = CosmoModel(Ωm=1.5, Ωλ=0.0)
y, a = runsimulation(cosmo)
ymax_year = round(seconds2years(y[end]/H₀) * 10^-9, digits=2)
plot(y, a, lw=2, xlabel='y', ylabel="Scale Factor a(y)", label="Ωₘ=1.5, Ωλ=0")
title!("The 'Big Crunch' in $ymax_year Billion Years")
end

# ╔═╡ d7d10fdf-a202-4b1d-a401-d2606fbb2817
md"If ``Ωₘ = 1.5``, what is the minimum value of ``Ω_λ`` such that the universe does not collapse back in on itself?"

# ╔═╡ 5687f633-f671-4e90-bf73-12e5e26a3446
@bind Ωₛ html"<input type='range' min='0.00907228' max='0.00907236' step='0.00000001' value='0.00907232'>"

# ╔═╡ cbf27243-05d8-44e2-a764-97e97ddbda19
let
cosmo = CosmoModel(Ωm=1.5, Ωλ=Ωₛ)
y, a = runsimulation(cosmo)
plot(y, a, lw=2, xlabel='y', ylabel="Scale Factor a(y)", label="Ωₘ=1.5, Ωλ=$Ωₛ")
title!("a(y) vs y")
end

# ╔═╡ 65ebaec8-facf-4c8e-8a93-b5d4cd239233
Ωₛ

# ╔═╡ Cell order:
# ╟─44427f8f-4a65-44da-9062-cce6e75e2569
# ╟─ecd37f62-bc2d-4256-95e9-b29424a246d6
# ╟─dcdb469e-1ec3-4fec-8bf1-d429719dcd9b
# ╟─2890c2ad-8409-45bf-8fd4-a6cd426ab55d
# ╟─316b59fa-ead6-4a1a-ab2f-c2ded137a0f2
# ╟─9cee1d18-0442-4dae-9e80-de38caa6163c
# ╟─9da1395a-6e7d-4bbe-a76d-5b35e6459b5a
# ╟─8a031c70-9d29-44ce-80fb-028c560cb51a
# ╟─ba2770bd-33a1-40f8-ae37-9a25a082b4af
# ╟─ba921154-fce7-4297-8980-eee506b6d653
# ╟─0f0a3b82-c424-4c20-ae3f-824514fe01d6
# ╟─50ff4ea4-8a4f-4179-9fc5-d554d4af4fcc
# ╠═400a2e78-afdb-11eb-2df6-7ff8a8e36528
# ╟─aae7f619-f21e-486f-88fd-6bb051c3b9a5
# ╟─eeb191c7-1ed5-4e8b-a408-9c4129166559
# ╟─ce002252-c4bc-4704-974f-73ff0b7139d7
# ╟─21e11baa-5239-4f05-83cf-bea77738e765
# ╟─844805b8-3e6e-496d-bce3-b33c6d26012a
# ╠═0f9a7e58-73bd-42bd-b77c-3a3e670a5de8
# ╟─1ece7af1-2cd6-4937-9e4f-2a064d1dc859
# ╠═539643eb-e04d-4515-b416-1e815b73fd77
# ╟─e01b33a4-f334-4633-a83c-93f5d67d2da2
# ╠═070c5d93-09fc-42a5-b90b-73ea44cdad40
# ╟─74ed32d4-6917-405e-b501-de1521070b53
# ╠═c44b31f2-d9e6-433f-a21f-a22ea78f9568
# ╟─bff766db-188e-484d-8b53-ebd71d00e120
# ╠═c756b29e-2a4a-4e4c-adce-fc633d3bc21e
# ╠═729c98bd-18a6-4395-abea-e21d899a9324
# ╠═8dbbaab7-c8a8-495a-b34e-2df3ee51be3f
# ╠═d82029ce-8163-4de2-bdac-6ffa0a867580
# ╟─3e5601e8-88b3-4062-902a-09518b592e4e
# ╠═dec2b537-cc4d-4075-a0a0-7e27b25998ca
# ╟─ba3010b9-41ee-4532-a7f5-2992c89abb97
# ╠═fdbd0b7e-26ad-45de-b42d-c407e120787b
# ╟─cdefb2ec-7a6d-40a9-90ea-3c1a6bd44904
# ╠═1d655ed7-9d23-47bf-a204-84d4eea9e3ea
# ╠═c459cb1e-0a34-4b6e-b41d-b4da1ad02c33
# ╟─c0af49f7-f4c2-4ac3-b9b1-157dd0dd1ca6
# ╟─998cf5a1-6888-4233-9310-6d4cc8c89537
# ╠═5f785097-5fe2-436a-98b6-d8aaf4e1a607
# ╠═4b8b8af4-2940-40c9-be7b-2743c85b79ac
# ╟─d7d10fdf-a202-4b1d-a401-d2606fbb2817
# ╠═cbf27243-05d8-44e2-a764-97e97ddbda19
# ╠═5687f633-f671-4e90-bf73-12e5e26a3446
# ╠═65ebaec8-facf-4c8e-8a93-b5d4cd239233
