FROM jupyter/datascience-notebook

RUN julia -e 'using Pkg; Pkg.add("LinearAlgebra")'
RUN julia -e 'using Pkg; Pkg.add("Plots")'
RUN julia -e 'using Pkg; Pkg.add("IterativeSolvers")'
RUN julia -e 'using Pkg; Pkg.add("PyPlot")'
