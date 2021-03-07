# General Physics

The 'Labs' folder contains Jupyter notebooks used for analysis in my lab class from Spring 2021. They should be pretty informative.

Besides that, there's just a lot of Pluto.jl files, so you need Julia and Pluto to actually run them. I'm gonna put em all on my website eventually. Includes:

## dftcs.jl
Using Forward in Time, Centered in Space (FTCS) algorithm to solve the diffusion equation.

## ndftcs.jl
Using Forward in Time, Centered in Space (FTCS) algorithm to solve the neutron diffusion equation (supercritical states).

## projectile.jl
Using Euler's Method to numerically calculate projectile motion of a ball launched at various angles.

## lotkavolterra.jl
Using Euler's Method to numerically calculate predator-prey populations over time.

# Labs
Junior Lab write-ups, Spring 2021

## PhotoelectricEffect.ipynb
Using Pandas, Scipy to analyze photoelectric backcurrent to experimentally calculate the stopping potential for a range of wavelengths.

<hr>
Based on projects I did for my Computational Physics class in Spring 2019.
The text I used for reference during the class was <a href="https://github.com/AlejGarcia/NM4P">Numerical Methods for Physics</a> by <a href="http://www.algarcia.org/nummeth/Programs2E.html">Alejandro Garcia</a>.<br><br>
<a href="http://web.cecs.pdx.edu/~gerry/class/ME448/lecture/pdf/FTCS_slides.pdf">Another useful reference</a>

<h4>Using Pluto.jl Notebooks</h4>
Note that you will have to install Pluto.jl and Plots.jl in the package manager (Pkg) to actually compile these notebooks.

In the Julia REPL (terminal):

<code>using Pkg</code><br>
<code>Pkg.add("Pluto")</code><br>
<code>Pkg.add("Plots")</code><br>
(There are other ways to do this)

Then, to run and open a Pluto server in your default browser (using port 1234), again in the Julia REPL:

<code>import Pluto</code><br>
<code>Pluto.run()</code>

Pluto should open automatically in your default browser. Then, you can actually just paste the URL for any one of these .jl files right into the 'Open from file' entry box.
