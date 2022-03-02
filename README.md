# General Physics

Some labwork/data analysis, some computational physics/simulations. Includes:

## Labs

Junior Lab write-ups (Spring 2021)

- **CriticalPoint**

Observing a phase change of SF<sub>6</sub> and calculating numerical values for the critical point (temperature, pressure, volume) using a curve-fitting routine.

- **PhotoelectricEffect**

Using Pandas, Scipy to analyze photoelectric backcurrent to experimentally calculate the stopping potential for a range of wavelengths.

- **NuclearMagneticResonance**

Fitting Nuclear Magnetic Resonance data to find the relaxation time and initial voltages for proton spins in a mineral oil solution.

- **FranckHertz**

Calculating the first excited energy of mercury.

- **DeepClean**

Using a Convolutional Neural Network to clean gravitational wave strain data from LIGO.

## ProjectileMotion

Calculating projectile motion, numerically accounting for linear air resistance using Euler's method.

- **Projectile.jl**
- **ProjectileMotion.ipynb**

## Other Stuff

- **Advection.jl**

Using Lax, Lax-Wendorff and Forward in Time, Centered in Space (FTCS) algorithms to solve the advection equation.

- **CosmologicalModel.jl**

Modeling the scale factor of the universe

- **Diffusion.jl**

Using Forward in Time, Centered in Space (FTCS) algorithm to solve the diffusion equation.

- **Laplace.jl**

Solving the [Laplace equation](https://tutorial.math.lamar.edu/Classes/DE/LaplacesEqn.aspx) using Jacobi, Gauss-Seidel, and Simultaneous Over Relaxation methods. (Jacobi method seems to be broken?)

- **LotkaVolterra.jl**

[Lotka-Volterra](https://en.wikipedia.org/wiki/Lotka%E2%80%93Volterra_equations) (predator-prey) simulation.

- **NeutronDiffusion.jl**

Using Forward in Time, Centered in Space (FTCS) algorithm to solve the neutron diffusion equation (supercritical states).

<hr>
See <a href="https://github.com/AlejGarcia/NM4P">Numerical Methods for Physics</a> by <a href="http://www.algarcia.org/nummeth/Programs2E.html">Alejandro Garcia</a>.
<hr>

## Using Pluto.jl Notebooks
[Pluto](https://www.juliapackages.com/p/pluto) is an active notebook environment; it's a lot like Jupyter, if you've used that before. I like Pluto notebooks 
because Pluto automatically updates all affected cells when you make a change.

Note that you will have to install Pluto.jl in the package manager (Pkg) to open `.jl` Pluto notebooks in your browser.

In the Julia REPL (terminal):

<code>using Pkg</code><br>
<code>Pkg.add("Pluto")</code>

(There are other ways to do this)

Then, to run and open a Pluto server in your default browser, again in the Julia REPL:

<code>import Pluto</code><br>
<code>Pluto.run()</code>

Pluto should open automatically in your default browser. Then, you can actually just paste the URL for any one of these .jl files right into the 'Open from file' entry box. 
Pluto installs packages directly into the notebook and keeps track of versions there, too. So you shouldn't need to install any other packages. 😄
