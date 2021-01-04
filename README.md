# DiffusionFTCS
Using Forward in Time, Centered in Space algorithm to solve the diffusion equation.

Based on a project I did for my Computational Physics class in Spring 2019.
The text I used for reference during the class was <a href="https://github.com/AlejGarcia/NM4P">Numerical Methods for Physics</a> by <a href="http://www.algarcia.org/nummeth/Programs2E.html">Alejandro Garcia</a>.<br><br>
<a href="http://web.cecs.pdx.edu/~gerry/class/ME448/lecture/pdf/FTCS_slides.pdf">Another useful reference</a>

<h4>Using Pluto.jl Notebooks</h4>
Note that you will have to install Pluto in the Julia Package manager to use the <code>@bind</code> macro properly in a Pluto notebook.

In the Julia REPL (terminal):

<code>Pkg add Pluto</code>

Then, to run and open a Pluto server in your default browser (using port 1234), again in the Julia REPL:

<code>import Pluto</code><br>
<code>Pluto.run()</code>

Pluto should open automatically in your default browser.
