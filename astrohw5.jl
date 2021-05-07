### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 0c3c36de-c631-4464-ac6a-94efb290275a
using Plots

# ╔═╡ 040b4af7-e473-479e-9144-52e75a835ed4
html"<h1>Homework 5</h1>"

# ╔═╡ 577d6a3f-e617-42f1-b17e-003623489195
html"<h2>1.</h2>"

# ╔═╡ 7561e27f-a602-44f9-9700-ffd321d70209
html"<h3 style='color: red'>e)</h3>"

# ╔═╡ 4caa6c0e-0ab1-4064-a031-47c861cabe21
L☉ = 3.828e26 		# W

# ╔═╡ a52f8846-5a4a-4740-ac0f-f8190f2a8d16
L = 4.5e9 * L☉		# W (luminosity of the supernova)

# ╔═╡ 902e1cb6-15e8-4844-bdaf-42c7bd545487
c = 299_792_458 	# m / s

# ╔═╡ 2d42720b-d313-430d-a134-f6fe515ef495
z = 0:.1:8

# ╔═╡ 27ce6a1c-b5ff-46d2-8665-94e2b80cf014
html"<h3 style='color: red'>f)</h3>"

# ╔═╡ e19b9961-5f0d-4487-96c8-bda6852bf6e9
html"<p>The predicted flux is <b>lower for the dark energy-dominated model</b>.</p>
<p>If <math>z=0.2</math>, the <b>relative difference</b> in predicted flux ΔF/F:</p>"

# ╔═╡ f32504d8-16e3-4a1e-a8e7-2b4153f34501
html"<h2>2 - Spiral Galaxy Rotation Curves</h3>"

# ╔═╡ 00c200ed-9821-461f-a233-49cc3cb24789
html"Note the weird units of <code>G</code>:"

# ╔═╡ 01894c96-e3cc-4d59-8169-b7e8af6bc85c
G = 4.30091e-6 	# kpc (km/s)² / M☉

# ╔═╡ 660ae40f-2367-462e-93e9-96008a6d34ab
html"Here, <code>ρ(r, a, ρ₀)</code> = ρ<sub>darkmatter</sub>:
<br><b>(ρ₀ has to have units of M☉ / kpc³)</b>"

# ╔═╡ 019b770d-3f5f-4742-8580-a2b7716a274c
ρ(r::Real, a::Real, ρ₀::Real) = ρ₀ / (1+(r/a)^2) 			# M☉ / kpc³

# ╔═╡ fa36a65d-3b41-433f-8610-66c433f01000
html"<h3 style='color: red'>a)</h3>"

# ╔═╡ 3018d6fe-92cc-417c-9c65-07ef6c2c4c34
html"This isn't a great fit for small R, to be honest. We're kind of ignoring the mass of the bulge in the center of the disk.<br><i>Now</i>, using a new function <code>ρ(r, a, b, ρ₀, ρᵦ)</code> = ρ<sub>bulge</sub> + ρ<sub>darkmatter</sub>:"

# ╔═╡ a125eda3-d19c-4935-973b-5b608a403e38
function ρ(r::Real, a::Real, b::Real, ρ₀::Real, ρᵦ::Real)
	ρᵦ*(1+(r/b)^2)^(-5/2) + ρ(r, a, ρ₀) 	# M☉ / kpc³
end

# ╔═╡ 06beacdf-1a54-4fc3-95f4-778caed427bd
M(r::Real, a::Real, ρ₀::Real) = (4π/3)*ρ(r, a, ρ₀)*r^3 		# M☉

# ╔═╡ 60b3c1fd-0a33-46f1-ac70-926ea125a66c
function M(r::Real, a::Real, b::Real, ρ₀::Real, ρᵦ::Real) 
	(4π/3)*ρ(r, a, b, ρ₀, ρᵦ)*r^3 			# M☉
end

# ╔═╡ 58af6d89-0ff7-4748-b289-9c393fdb1b91
v₁(r::Real; a::Real, ρ₀::Real) = √(G*M(r, a, ρ₀)/r) 		# km / s

# ╔═╡ 77c9f36f-4afc-4f42-8722-beaeb6b53435
let
r = 0:.5:30
v = v₁.(r, a=4, ρ₀=82_000_000)
plot(r, v, legend=false, title="Velocity vs Radius", lw=2, ylim=(0,160),
		xlabel="R (kpc)", ylabel="V(R) (km/s)")
end

# ╔═╡ 037f4c56-3b3b-412b-b5eb-d8d2e5041ffb
function v₂(r::Real; a::Real, b::Real, ρ₀::Real, ρᵦ::Real) 
	√(G*M(r, a, b, ρ₀, ρᵦ)/r) 				# km / s
end

# ╔═╡ 99ce2830-e470-48da-80bb-a4c1363e7cba
html"<h3 style='color: red'>b)</h3>"

# ╔═╡ 42dfc66a-e89f-479d-8bdd-0ce5b66589c1
let
r = 0:.3:30
v = v₂.(r, a=3.2, b=3.0, ρ₀=125_000_000, ρᵦ=400_000_000)
plot(r, v, legend=false, title="Velocity vs Radius", lw=2, ylim=(0,165),
	xlabel="R (kpc)", ylabel="V(R) (km/s)")
end

# ╔═╡ b9b10c00-5ff1-4f3a-9d7c-8e2fa27be781
html"Given these constants, what is <math>M(r = 30 kpc)</math>?<br>(Units of M☉)"

# ╔═╡ f5030ce2-a0a6-4700-8c5c-e7523c0128e8
mass = M(30, 3.2, 3.0, 120_000_000, 400_000_000)

# ╔═╡ 03f6d075-c87e-4c4f-b446-1dcaedbbc639
html"In kilograms:"

# ╔═╡ 86751fee-284b-4e9f-8313-5897778c14b0
mass * 5.9742e24

# ╔═╡ 9b8629b4-9e07-4448-a4c3-f0efb6c76a1c
html"<h2>Extra Credit</h2>
<p>Behold! Feast your eyes on an extremely jenky solution...</p>
<p>Don't recklessly change any hard-coded values or everything could break 🙈</p>
<p>The information about our cosmological model will be stored in a struct so we can step-advance more than one cosmological model at once:</p>"

# ╔═╡ 47ed13cf-8f82-4ad9-ab85-95784c725631
@Base.kwdef mutable struct CosmoModel
	a = 1.0
	da = 1.0
	Ωm = 0.3
	Ωλ = 0.7
	y = 0 		# used in part e)
	y_rec = 5 	# used in part e) - minimum y where dda ≥ 0 in step function
end

# ╔═╡ 8df34adf-0566-473a-a63d-57fc59bfa668
function step!(c::CosmoModel, dy::Real=0.01)
	# Euler's method, what else?
	dda = -0.5*c.Ωm/c.a^2 + c.Ωλ*c.a
	c.da += dda * dy
	c.a += c.da * dy
	c.y += dy 	# recording for part e)
	dda ≥ 0 && (c.y_rec = min(c.y_rec, c.y))
end

# ╔═╡ 1307dae0-0f48-42a5-af76-899ed7533bbf
html"<b>Note</b>: If I had to redo this question, I would make this first part a little more dynamic. Oh well. Just don't mess with the size of the arrays or anything like that."

# ╔═╡ d91662c2-065e-40ac-a9b4-a438633d3270
html"Initializing the plot of a(t) as an empty array:"

# ╔═╡ 07548dcd-c88c-4772-af53-9411276f03e5
begin
aplot = zeros(401, 3)
aplot[201, :] = [1.0 1.0 1.0] # initial conditions at y=0 are centered in aplot
end

# ╔═╡ 4a325eb5-c7d1-4d2c-9bf4-cec22338ca9b
html"Forward time integration:"

# ╔═╡ fdb67d82-51e0-4e15-9a76-76e53eb020c9
let
cosmos = [CosmoModel(Ωλ=0), CosmoModel(Ωm=0), CosmoModel()]
# Double loop over all cosmos, y in 202:401
for (i, cosmo) ∈ enumerate(cosmos), y ∈ 202:401
	step!(cosmo)
	aplot[y, i] = cosmo.a
end
end

# ╔═╡ ff881e1b-f5ad-464d-863a-7ddb7de47e6f
html"Backward time integration, <b>and</b> we will use <code>cosmos[3].y_rec</code> for part e) (finding the value of y when <math>d²a/dy² = 0</math> for the benchmark model):"

# ╔═╡ b17c8333-b145-469e-b4fd-d6f63b087ad5
let
cosmos = [CosmoModel(Ωλ=0), CosmoModel(Ωm=0), CosmoModel()]
for (i, cosmo) ∈ enumerate(cosmos), y ∈ 1:201
	step!(cosmo, -0.01)
	aplot[202-y, i] = cosmo.a
end
cosmos[3].y_rec 	# Note this value for part e)! It's when d²a/dy²=0 ↑
end

# ╔═╡ 5e17baec-9ce0-406b-8521-7b4f7278a0a1
izeros = [findfirst(≥(0), aplot[:, i]) for i ∈ 1:3]

# ╔═╡ 9229f0d3-e01e-4694-a697-8cbf062d47df
yzeros = [(-2:0.01:2)[i] for i ∈ izeros]

# ╔═╡ de1ab1c9-0f3d-4e71-8b65-7e2ed851ca4a
html"<h3 style='color: red'>c)</h3>"

# ╔═╡ 787a8efd-ee3a-415d-b4bc-f4a7b6ba5607
let
y = -1.5:0.01:2
plot(y, aplot[402-length(y):end, 1], lw=2, label="Ωλ=0", legend=:topleft)
plot!(y, aplot[402-length(y):end, 2], lw=2, label="Ωₘ=0")
plot!(y, aplot[402-length(y):end, 3], lw=2, label="Benchmark Model")
plot!(ylim=(0,6), xlabel="y", ylabel="a(y)", title="Scale Factor a(y) vs. y")
vline!(yzeros, label="Zeros: y = $(sort(yzeros))", linestyle=:dash)
annotate!(0, 2, "Today, y=0")
end

# ╔═╡ 3d1ffefc-0f81-4dc8-9c44-d6f2fcfa37f0
html"Converting these lookback times into units of years (rather than the dimensionless units we have now):"

# ╔═╡ 8091daae-ad29-11eb-0ec8-6b5fe5400186
H₀ = 70*3.2407792700054e-20 	# 1 / s

# ╔═╡ 1f448b64-2b8c-41af-b1e8-08cc9e797754
Δt = -log(.5)/H₀

# ╔═╡ b5aaf054-297d-4dfb-ad03-852c30383ec5
F(z) = L*H₀^2 / (4π*c^2*z^2*(1+z)^2)

# ╔═╡ bd52d08d-d90b-44e5-84d2-2e734b5aaec2
plot(z, F.(z), lw=2, yaxis=:log, leg=false, title="Supernova Flux vs. Redshift",
	xlabel="z", ylabel="Flux (Watts/meter²)")

# ╔═╡ 49f7d677-8d3b-4953-bcb8-020e2b64f6f7
F₂(z) = L*H₀^2 / (16π*c^2 * (1+z)^2 * (1 - 1/√(1+z))^2)

# ╔═╡ 433ecea6-7f0b-43a8-acc1-1ba7aebc130e
let
plot(z, F₂.(z), lw=2, label="Matter-dominated flat universe", yaxis=:log)
plot!(z, F.(z), lw=2, label="Dark energy-dominated flat universe")
plot!(title="Supernova Flux vs. Redshift", xlabel="z", ylabel="Flux (Watts/meter²)")
end

# ╔═╡ 11f5fbf8-d85d-409f-a71a-cf3eed933913
let
z = 0.2
F̄ = sum([F(z) F₂(z)]) / 2 # Let's use the average flux for F
ΔF = F₂(z) - F(z)
ΔF/F̄
end

# ╔═╡ 827646fe-7ea9-4c15-928b-685f5d18ad1e
seconds2years(s::Real) = s / (60*60*24*365)

# ╔═╡ f21dd248-760a-45e2-8643-3a58f9988ded
seconds2years(Δt)

# ╔═╡ 466dcb0c-9511-4d67-9764-ea50909c30ed
html"<p>Recalling <math>y=H₀t</math>,</p>
<p>the times at which <math>a(t)=0</math> for each model (Ω<sub>m</sub>=0, Ω<sub>λ</sub>=0, and the Benchmark Model, respectively) are:</p>"

# ╔═╡ fb11fea2-321e-4509-b571-d4d4ccb0bcde
bya = seconds2years.([y/H₀ for y ∈ yzeros]) * 10^-9

# ╔═╡ 82c00766-eb60-4572-90f4-401ce686fc67
html"<h3 style='color: red'>d)</h3>
Thus the age of the universe (in billion years) for each respective model is"

# ╔═╡ 00e60bac-cd19-4cd0-8759-3ffcfd210013
("Ωₘ=0:", abs(bya[1])), ("Ωλ=0:", abs(bya[2])), ("Benchmark:", abs(bya[3]))

# ╔═╡ 4ffabfe9-0dc7-4ffc-aac5-8d80bef03d1b
html"<h3 style='color: red'>e)</h3>
Recalling that we found the benchmark to have <math>d²a/dy²=0</math> at <math>y=-0.45000000000000023</math>, we can once again use <math>y=H₀t</math> to calculate how many <b>billion years ago</b> this occured:"

# ╔═╡ 369ce38b-890d-49f8-b080-2084c7ea6585
seconds2years(0.45000000000000023/H₀) * 10^-9

# ╔═╡ 0975ee72-ed50-4e47-8096-2fbc24570555
html"<h3 style='color: red'>f)</h3>"

# ╔═╡ 672a325d-f155-40bd-bd0c-331abfd72457
let
cosmo = CosmoModel(Ωm=1.5, Ωλ=0.0)
dy = 0.01
a = [cosmo.a]
for _ ∈ 1:2000
	step!(cosmo, dy)
	cosmo.a ≤ 0 && continue
	push!(a, cosmo.a)
end
y = 0:dy:dy*(length(a)-1)
ymax_year = round(seconds2years(y[end]/H₀) * 10^-9, digits=2)
plot(y, a, lw=2, xlabel='y', ylabel="Scale Factor a(y)", label="Ωₘ=1.5, Ωλ=0")
title!("The 'Big Crunch' in $ymax_year Billion Years")
end

# ╔═╡ 3476b5a9-7b77-41c1-af13-d69b06ce8cc5
html"↓ This slider controls our value for Ωₛ! ↓"

# ╔═╡ b37babe0-a615-4ff9-9693-9f1a50a30b2c
@bind Ωₛ html"<input type='range' min='0.00907228' max='0.00907238' step='0.00000001' value='0.00907230'>"

# ╔═╡ ff69bb57-52c0-48b5-a0e5-e1ae2fbf9ea3
let
cosmo = CosmoModel(Ωm=1.5, Ωλ=Ωₛ)
dy = 0.01
a = [cosmo.a]
for _ ∈ 1:10_000
	step!(cosmo, dy)
	cosmo.a ≤ 0 && continue
	push!(a, cosmo.a)
end
y = 0:dy:dy*(length(a)-1)
plot(y, a, lw=2, xlabel='y', ylabel="Scale Factor a(y)", label="Ωₘ=1.5, Ωλ=$Ωₛ")
title!("a(y) vs y")
end

# ╔═╡ a28843c4-208e-46de-bc51-2e8d9415ead9
Ωₛ

# ╔═╡ 2fbf4aa1-ef1e-4937-85bb-f675123261af
html"Minimum value for Ωₛ to avoid the big crunch is <b>0.00907232</b>"

# ╔═╡ Cell order:
# ╟─040b4af7-e473-479e-9144-52e75a835ed4
# ╠═0c3c36de-c631-4464-ac6a-94efb290275a
# ╟─577d6a3f-e617-42f1-b17e-003623489195
# ╠═1f448b64-2b8c-41af-b1e8-08cc9e797754
# ╠═f21dd248-760a-45e2-8643-3a58f9988ded
# ╟─7561e27f-a602-44f9-9700-ffd321d70209
# ╠═4caa6c0e-0ab1-4064-a031-47c861cabe21
# ╠═a52f8846-5a4a-4740-ac0f-f8190f2a8d16
# ╠═902e1cb6-15e8-4844-bdaf-42c7bd545487
# ╠═b5aaf054-297d-4dfb-ad03-852c30383ec5
# ╠═2d42720b-d313-430d-a134-f6fe515ef495
# ╠═bd52d08d-d90b-44e5-84d2-2e734b5aaec2
# ╟─27ce6a1c-b5ff-46d2-8665-94e2b80cf014
# ╠═49f7d677-8d3b-4953-bcb8-020e2b64f6f7
# ╠═433ecea6-7f0b-43a8-acc1-1ba7aebc130e
# ╟─e19b9961-5f0d-4487-96c8-bda6852bf6e9
# ╠═11f5fbf8-d85d-409f-a71a-cf3eed933913
# ╟─f32504d8-16e3-4a1e-a8e7-2b4153f34501
# ╟─00c200ed-9821-461f-a233-49cc3cb24789
# ╠═01894c96-e3cc-4d59-8169-b7e8af6bc85c
# ╟─660ae40f-2367-462e-93e9-96008a6d34ab
# ╠═019b770d-3f5f-4742-8580-a2b7716a274c
# ╠═06beacdf-1a54-4fc3-95f4-778caed427bd
# ╠═58af6d89-0ff7-4748-b289-9c393fdb1b91
# ╟─fa36a65d-3b41-433f-8610-66c433f01000
# ╠═77c9f36f-4afc-4f42-8722-beaeb6b53435
# ╟─3018d6fe-92cc-417c-9c65-07ef6c2c4c34
# ╠═a125eda3-d19c-4935-973b-5b608a403e38
# ╠═60b3c1fd-0a33-46f1-ac70-926ea125a66c
# ╠═037f4c56-3b3b-412b-b5eb-d8d2e5041ffb
# ╟─99ce2830-e470-48da-80bb-a4c1363e7cba
# ╠═42dfc66a-e89f-479d-8bdd-0ce5b66589c1
# ╟─b9b10c00-5ff1-4f3a-9d7c-8e2fa27be781
# ╠═f5030ce2-a0a6-4700-8c5c-e7523c0128e8
# ╟─03f6d075-c87e-4c4f-b446-1dcaedbbc639
# ╠═86751fee-284b-4e9f-8313-5897778c14b0
# ╟─9b8629b4-9e07-4448-a4c3-f0efb6c76a1c
# ╠═47ed13cf-8f82-4ad9-ab85-95784c725631
# ╠═8df34adf-0566-473a-a63d-57fc59bfa668
# ╟─1307dae0-0f48-42a5-af76-899ed7533bbf
# ╟─d91662c2-065e-40ac-a9b4-a438633d3270
# ╠═07548dcd-c88c-4772-af53-9411276f03e5
# ╟─4a325eb5-c7d1-4d2c-9bf4-cec22338ca9b
# ╠═fdb67d82-51e0-4e15-9a76-76e53eb020c9
# ╟─ff881e1b-f5ad-464d-863a-7ddb7de47e6f
# ╠═b17c8333-b145-469e-b4fd-d6f63b087ad5
# ╠═5e17baec-9ce0-406b-8521-7b4f7278a0a1
# ╠═9229f0d3-e01e-4694-a697-8cbf062d47df
# ╟─de1ab1c9-0f3d-4e71-8b65-7e2ed851ca4a
# ╠═787a8efd-ee3a-415d-b4bc-f4a7b6ba5607
# ╟─3d1ffefc-0f81-4dc8-9c44-d6f2fcfa37f0
# ╠═8091daae-ad29-11eb-0ec8-6b5fe5400186
# ╠═827646fe-7ea9-4c15-928b-685f5d18ad1e
# ╟─466dcb0c-9511-4d67-9764-ea50909c30ed
# ╠═fb11fea2-321e-4509-b571-d4d4ccb0bcde
# ╟─82c00766-eb60-4572-90f4-401ce686fc67
# ╠═00e60bac-cd19-4cd0-8759-3ffcfd210013
# ╟─4ffabfe9-0dc7-4ffc-aac5-8d80bef03d1b
# ╠═369ce38b-890d-49f8-b080-2084c7ea6585
# ╟─0975ee72-ed50-4e47-8096-2fbc24570555
# ╠═672a325d-f155-40bd-bd0c-331abfd72457
# ╠═ff69bb57-52c0-48b5-a0e5-e1ae2fbf9ea3
# ╟─3476b5a9-7b77-41c1-af13-d69b06ce8cc5
# ╟─b37babe0-a615-4ff9-9693-9f1a50a30b2c
# ╠═a28843c4-208e-46de-bc51-2e8d9415ead9
# ╟─2fbf4aa1-ef1e-4937-85bb-f675123261af
