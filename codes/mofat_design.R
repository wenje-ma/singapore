##################################################################
# mofat_design.R — MOFAT screening design (total Sobol' index)
#
# Total Sobol' index estimator (Jansen 1999):
#   V̂_i^{tot} = (1/2m) || h(A) - h(A^{(B_i)}) ||²                (2)
# Its expectation:
#   E(V̂_i^{tot}) = (τ² √w_i / 2m) Σ_j | A_ji - A_ji^{(i)} |      (3)
# Max-OFAT criterion (max L1 distance maximizes (3)):
#   argmax_A Σ_j | A_ji - A_ji^{(i)} |                            (4)
# Projection mapping (A and B take the two branches alternately):
#   x_i ← x_i ∓ 0.25/m   (branch depends on x_i < 0.5 or ≥ 0.5)   (5)
# The result is the max OFAT design with projection. Screening keeps
# only factors whose MOFAT::measure mustar exceeds the median.
# Built via MOFAT::mofat(p, m, method="projection"), split into
# blocks A, C1, C2 used to estimate each factor's total effect.
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
mofat_design=function(p,m,seed=1){
  library(MOFAT);set.seed(seed)
  Dm=mofat(p,m,method="projection")
  list(A=Dm[1:m,],C1=Dm[(m+1):(2*m),],C2=Dm[(2*m+1):(3*m),])
}