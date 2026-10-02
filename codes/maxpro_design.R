##################################################################
# maxpro_design.R — maximum projection initial design
#
# Maximum projection design (Joseph et al. 2015): D = {x1..xn} on [0,1]^p
#   min_D  Σ_i Π_{j≠i}  1 / Σ_{k=1}^p (x_ik - x_jk)²            (1)
# The denominator cannot vanish, so coordinates are distinct in every
# projection, satisfying the maximin constraint automatically.
# Built here via SFDesign::maxpro.optim starting from a random Latin
# hypercube; this is the starting design of the pipeline.
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
library(SFDesign);library(lhs)
maxpro_design=function(n,p,seed=1){
  set.seed(seed)
  D=maxpro.optim(randomLHS(n,p))$design
  matrix(D,nrow=n,ncol=p)
}
