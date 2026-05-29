#!/usr/bin/env julia
# Export CMBLensing CAMB Cls to numpy format for use in lensit_full_comparison.py.
# Run once: julia export_julia_cls.jl
# Output: results/lensit/julia_cls.npz

import Pkg; Pkg.activate(@__DIR__)
using CMBLensing
using Printf
using PythonCall: pyimport

ℓmax_export = 12500
println("Running CAMB (r=0.05, ℓmax=$ℓmax_export) ...")
Cl = camb(r=0.05, ℓmax=ℓmax_export)
println("CAMB done. Params: ", Cl.params)

ells = 0:12000
cl_pp     = [ℓ < 2 ? 0.0 : Float64(Cl.unlensed_scalar.ϕϕ(ℓ)) for ℓ in ells]
cl_tt_unl = [ℓ < 2 ? 0.0 : Float64(Cl.unlensed_scalar.TT(ℓ)) for ℓ in ells]
cl_tt_len = [ℓ < 2 ? 0.0 : Float64(Cl.lensed_scalar.TT(ℓ)   ) for ℓ in ells]

np = pyimport("numpy")
out = "results/lensit/julia_cls.npz"
np.savez(out,
    cl_pp=cl_pp, cl_tt_unl=cl_tt_unl, cl_tt_len=cl_tt_len,
    ells=collect(ells))
println("Saved → $out")
println("  cl_pp[100]    = ", cl_pp[101])
println("  cl_tt_unl[100]= ", cl_tt_unl[101])
println("  cl_tt_len[100]= ", cl_tt_len[101])
