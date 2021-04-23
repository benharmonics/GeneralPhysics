### A Pluto.jl notebook ###
# v0.14.3

using Markdown
using InteractiveUtils

# ╔═╡ 32ae409c-9ed9-11eb-3ce8-2bef48bebcae
using CSV, DataFrames, Plots

# ╔═╡ 6779c065-2fa6-4630-8263-65ce31f1488f
html"<h1>Franck-Hertz Experiment</h1>
<h2>Calculating the first excited energy of mercury</h2>
<div style='margin-left: 40px'>
	<p>Benjamin Jiron</p>
	<p>April 2021</p>
	<p>Junior Lab</p>
</div>"

# ╔═╡ c04d9cd2-684f-466a-af91-d61bea5761dc
begin
df = CSV.File("FranckHertzData.csv") |> DataFrame
df[1:5, :]
end

# ╔═╡ 8c24fdc4-77d7-4d97-a617-f1cf12c9c469
begin
plot(df[!, "Voltage"], df[!, "180C"], label="T=180°C", lw=2)
plot!(df[!, "Voltage"], df[!, "195C"], label="T=195°C", lw=2)
plot!(df[!, "Voltage"], df[!, "210C"], label="T=210°C", lw=2)
plot!(title="Anode Current vs. Voltage", xlabel="Voltage (V)", ylabel="Current (A)",
	legend=:topleft)
end

# ╔═╡ 5ddc7b4a-4060-4b12-96c9-3e8ab707b5a7
html"<h4>There's a lot of noise before Voltage=10V so let's just drop that part and analyze the rest:</h4>"

# ╔═╡ fc7f0733-7d93-474c-9688-73a02c6a51cc
begin
T = df[df[!, "Voltage"] .> 10, :] 	# Filtering
T₁ = select(T, "Voltage", "180C") 	# ⇒ :lowtemp
T₂ = select(T, "Voltage", "195C") 	# ⇒ :medtemp
T₃ = select(T, "Voltage", "210C") 	# ⇒ :hightemp
rename!(T₁, "180C" => "Current") 	# Renaming columns
rename!(T₂, "195C" => "Current")
rename!(T₃, "210C" => "Current")
T₁[1:5, :], T₂[1:5, :], T₃[1:5, :]
end

# ╔═╡ d30c9e49-0d28-4882-93fd-9354dce62432
html"<h4>Let's set up some naïve filtering functions to try and pick out maximum and minimum currents, and two corrective functions in case we miss:</h34>"

# ╔═╡ 5e945e11-869f-4040-af71-c79dd0351f60
function argminima(v::Vector)::Vector
	N = length(v)
	minima = []
	for i ∈ 2:(N-1)
		(v[i] ≤ v[i-1] && v[i] < v[i+1]) && push!(minima, i)
	end
	minima
end

# ╔═╡ f5b8520b-0d99-4e8a-8460-32dc1420deb3
function argmaxima(v::Vector)::Vector
	N = length(v)
	maxima = []
	for i ∈ 2:(N-1)
		(v[i] ≥ v[i-1] && v[i] > v[i+1]) && push!(maxima, i)
	end
	maxima
end

# ╔═╡ fb4b04e8-5901-4a7c-bd6d-19c4201fbf01
function correctminima!(iminima::Vector, v::Vector)
	corrections = []
	k = 10 		# We're going to check k nearest neighbors for local minima
	for i ∈ iminima
		nearbypoints = v[i-k:i+k]
		correction = argmin(nearbypoints) - (k+1) # set correction = 0 if not needed
		push!(corrections, correction)
	end
	iminima .+= corrections
	unique!(iminima)
end

# ╔═╡ 4b6207e2-e835-4c26-a252-734986b31f14
function correctmaxima!(imaxima::Vector, v::Vector)
	corrections = []
	k = 10 		# k nearest neighbors on each side
	for i ∈ imaxima
		nearbypoints = v[i-k:i+k]
		correction = argmax(nearbypoints) - (k+1) # correction = 0 if not needed
		push!(corrections, correction)
	end
	imaxima .+= corrections
	unique!(imaxima)
end

# ╔═╡ 9053e773-18fc-43f4-b54b-872a4d22dcb8
html"<h4>We'll use these two Dicts, <code>allminima</code> and <code>allmaxima</code> to keep track of our extrema:</h4>"

# ╔═╡ c30ee767-87cd-44e4-a7a2-a752828c80d4
begin
allminima = Dict()
allmaxima = Dict()
end

# ╔═╡ 8e681f02-2f7b-49f5-b10b-fd448141dd93
let
# Get indices of maxima using our function
imaxima = argmaxima(T₁.Current)
# Make minor corrections to the indices found
correctmaxima!(imaxima, T₁.Current)
# Get corresponding voltages
maxvoltages = T₁[imaxima, :Voltage]
# Repeat for the minima
iminima = argminima(T₁.Current)
correctminima!(iminima, T₁.Current)
minvoltages = T₁[iminima, :Voltage]
# Record unique minima/maxima in the dictionaries
allminima[:lowtemp] = minvoltages
allmaxima[:lowtemp] = maxvoltages
# Plotting
plot(T₁.Voltage, T₁.Current*10^9, label=false, legend=:topleft, lw=2)
vline!(minvoltages, linestyle=:dash, label="Calculated Minima", lw=2)
vline!(maxvoltages, linestyle=:dot, label="Calculated Maxima", lw=2)
plot!(title="Current vs Voltage (180°C)", xlabel="Volts", ylabel="Nanoamperes")
end

# ╔═╡ 0d8d30ab-20dd-4d53-9d8e-ddaa2d1d6182
html"<h3>That naïve filtering function worked really well on the first dataset, but the next two need some adjusting:</h3>"

# ╔═╡ 332f7f3e-af9b-4d2b-8e22-551d3cb49213
let
imaxima = argmaxima(T₂.Current)
correctmaxima!(imaxima, T₂.Current)
maxvoltages = T₂[imaxima, :Voltage]
iminima = argminima(T₂.Current)
correctminima!(iminima, T₂.Current)
minvoltages = T₂[iminima, :Voltage]
# New step: filter out bad data (the region below 18V is pretty noisy)
filter!(>(18), minvoltages) 	# some trial & error to find these filters
filter!(≠(35.3), minvoltages) 	# if you miss TOO badly the correction function fails
filter!(>(15), maxvoltages)
allminima[:medtemp] = minvoltages
allmaxima[:medtemp] = maxvoltages
plot(T₂.Voltage, T₂.Current*10^9, label=false, legend=:topleft, lw=2, c=:orange)
vline!(minvoltages, linestyle=:dash, label="Calculated Minima", lw=2)
vline!(maxvoltages, linestyle=:dot, label="Calculated Maxima", lw=2)
plot!(title="Current vs Voltage (195°C)", xlabel="Volts", ylabel="Nanoamperes")
end

# ╔═╡ 2dd9a2c7-5279-4c5f-9c02-9f006f8fff3e
let
imaxima = argmaxima(T₃.Current)
correctmaxima!(imaxima, T₃.Current)
maxvoltages = T₃[imaxima, :Voltage]
iminima = argminima(T₃.Current)
correctminima!(iminima, T₃.Current)
minvoltages = T₃[iminima, :Voltage]
filter!(>(20), minvoltages) 			# a bit more trial and error
filter!(∉([21.4, 23.6]), minvoltages)
filter!(>(20.2), maxvoltages)
allminima[:hightemp] = minvoltages
allmaxima[:hightemp] = maxvoltages
plot(T₃.Voltage, T₃.Current*10^9, label=false, legend=:topleft, lw=2, c=:green)
vline!(minvoltages, linestyle=:dash, label="Calculated Minima", lw=2)
vline!(maxvoltages, linestyle=:dot, label="Calculated Maxima", lw=2)
plot!(title="Current vs Voltage (210°C)", xlabel="Volts", ylabel="Nanoamperes")
end

# ╔═╡ fc26a4e5-1050-4d4d-97cb-2e2b4262d9cd
html"<h2>Finding Eₐ (first excited energy of mercury)</h2>
<h4>We expect the energy difference between the first and second excited states of mercury to be about equal to the mean ΔE:</h4>"

# ╔═╡ d20116e4-20e8-4f69-b965-924fd5e69027
results = DataFrame(:Temperature => ["180°C", "195°C", "210°C"], :Eₐ => 0.0);

# ╔═╡ 64961f92-6ab1-49d2-9eb2-53bf92f986df
mean(X::Vector) = sum(X) / length(X)

# ╔═╡ 7f7ab7a9-39a9-4954-bbd0-7ad4210c6c1a
html"ΔE for 180°C → ( [ΔE<sub>minima</sub>], [ΔE<sub>maxima</sub>] )"

# ╔═╡ 5fe21528-e4f8-4377-ae03-c0b3dd64ed2f
let
# α and β are dummy variables which represent our min/max voltages, respectively
α = allminima[:lowtemp]
β = allmaxima[:lowtemp]
# Find differences in voltages between peaks
ΔE₁ = [α[i+1] - α[i] for i ∈ 1:(length(α)-1)] 
ΔE₂ = [β[i+1] - β[i] for i ∈ 1:(length(β)-1)]
# Recording results (Eₐ is mean of means of ΔE₁, ΔE₂)
results[1, :Eₐ] = mean([mean(ΔE₁), mean(ΔE₂)])
ΔE₁, ΔE₂
end

# ╔═╡ c0453f52-c9d6-4361-be6e-0981f6e62246
html"195°C"

# ╔═╡ a45de7a9-0fa3-44f0-abc6-3b6d4380d6ee
let
α = allminima[:medtemp]
β = allmaxima[:medtemp]
ΔE₁ = [α[i+1] - α[i] for i ∈ 1:(length(α)-1)] 
ΔE₂ = [β[i+1] - β[i] for i ∈ 1:(length(β)-1)]
results[2, :Eₐ] = mean([mean(ΔE₁), mean(ΔE₂)])
ΔE₁, ΔE₂
end

# ╔═╡ 0cd63574-2afc-43e1-a02f-4ec8eb3d70bc
html"210°C"

# ╔═╡ 39b549f1-7ef6-41e8-9211-ea1266b347c5
let
α = allminima[:hightemp]
β = allmaxima[:hightemp]
ΔE₁ = [α[i+1] - α[i] for i ∈ 1:(length(α)-1)]
ΔE₂ = [β[i+1] - β[i] for i ∈ 1:(length(β)-1)]
results[3, :Eₐ] = mean([mean(ΔE₁), mean(ΔE₂)])
ΔE₁, ΔE₂
end

# ╔═╡ 78669699-861e-4e3b-b405-88088b303285
html"<h2>Thus:</h2>"

# ╔═╡ 4a84abb7-01dc-43e6-9f38-c2a658d33d98
results

# ╔═╡ Cell order:
# ╟─6779c065-2fa6-4630-8263-65ce31f1488f
# ╠═32ae409c-9ed9-11eb-3ce8-2bef48bebcae
# ╠═c04d9cd2-684f-466a-af91-d61bea5761dc
# ╠═8c24fdc4-77d7-4d97-a617-f1cf12c9c469
# ╟─5ddc7b4a-4060-4b12-96c9-3e8ab707b5a7
# ╠═fc7f0733-7d93-474c-9688-73a02c6a51cc
# ╟─d30c9e49-0d28-4882-93fd-9354dce62432
# ╠═5e945e11-869f-4040-af71-c79dd0351f60
# ╠═f5b8520b-0d99-4e8a-8460-32dc1420deb3
# ╠═fb4b04e8-5901-4a7c-bd6d-19c4201fbf01
# ╠═4b6207e2-e835-4c26-a252-734986b31f14
# ╟─9053e773-18fc-43f4-b54b-872a4d22dcb8
# ╠═c30ee767-87cd-44e4-a7a2-a752828c80d4
# ╠═8e681f02-2f7b-49f5-b10b-fd448141dd93
# ╟─0d8d30ab-20dd-4d53-9d8e-ddaa2d1d6182
# ╠═332f7f3e-af9b-4d2b-8e22-551d3cb49213
# ╠═2dd9a2c7-5279-4c5f-9c02-9f006f8fff3e
# ╟─fc26a4e5-1050-4d4d-97cb-2e2b4262d9cd
# ╠═d20116e4-20e8-4f69-b965-924fd5e69027
# ╠═64961f92-6ab1-49d2-9eb2-53bf92f986df
# ╟─7f7ab7a9-39a9-4954-bbd0-7ad4210c6c1a
# ╠═5fe21528-e4f8-4377-ae03-c0b3dd64ed2f
# ╟─c0453f52-c9d6-4361-be6e-0981f6e62246
# ╠═a45de7a9-0fa3-44f0-abc6-3b6d4380d6ee
# ╟─0cd63574-2afc-43e1-a02f-4ec8eb3d70bc
# ╠═39b549f1-7ef6-41e8-9211-ea1266b347c5
# ╟─78669699-861e-4e3b-b405-88088b303285
# ╠═4a84abb7-01dc-43e6-9f38-c2a658d33d98
