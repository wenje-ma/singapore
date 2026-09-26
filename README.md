# Bayesian Optimization Based on Multi-Fidelity Data

Research project and report on **multi-fidelity Bayesian optimization** — optimizing an expensive black-box function when two evaluation channels are available: a cheap low-fidelity simulator with systematic bias, and an accurate but expensive high-fidelity simulator. Under an extremely small budget (15 high-fidelity equivalents), the project assembles and ablates a pipeline of experimental-design components and quantifies each component's contribution.

- **Author:** Wenje Ma — Beijing Institute of Technology, Mathematics and Applied Mathematics (Qiangji Program), 2024
- **Advisor:** Dianpeng Wang

## Overview

The design parameters live in $\boldsymbol{x}\in[0,1]^{p}$, and the simulator is a black box $y=h(\boldsymbol{x})$. Two evaluation channels are available:

| Channel | Cost | Accuracy |
| --- | --- | --- |
| Low-fidelity $h_\mathrm{L}(\boldsymbol{x})$ | cheap, $c_\mathrm{L}$ | systematic bias |
| High-fidelity $h_\mathrm{H}(\boldsymbol{x})$ | expensive, $c_\mathrm{H} \gg c_\mathrm{L}$ | accurate |

The bias structure between the two fidelities is unknown. The goal is to estimate $\widehat{\boldsymbol{x}} \approx \arg\min_{\boldsymbol{x}\in[0,1]^p} h_\mathrm{H}(\boldsymbol{x})$ as accurately as possible under a total budget of 15 high-fidelity evaluations.

## Pipeline

The complete pipeline **M1** combines four experimental-design components:

```
Maximum projection design → Sequential design → Nested design → Expected improvement
```

To attribute each component's contribution, the report also defines three control configurations:

- **M0** — blank control: `Maximum projection design → Expected improvement`
- **S1** — M1 without the nested (fusion) design
- **S2** — M1 without the sequential design

### Key findings

- **Calibration:** under the tiny 15-equivalent budget, the optimum falls on the grid endpoint, so the initial design dominates and the multi-fidelity components have little room.
- **Fusion is the decisive component:** in 1-D it turns failure into feasibility and reaches the global optimum; in 2-D it approaches the Branin optimum; its value decays with dimension and fails in 8-D (curse of dimensionality within the multi-fidelity framework).
- **Screening never contributes:** the bias between low and high fidelity makes factor-importance ranking unreliable.
- Under the same budget, a few high-fidelity points **with** fusion far outperform many high-fidelity points alone.

## Repository structure

```
singapore/
├── codes/              # R implementation of the pipeline
│   ├── maxpro_design.R     # Maximum projection design
│   ├── mofat_design.R      # Max one-factor-at-a-time design with projection
│   ├── nested_design.R     # Nested (multi-fidelity) design
│   ├── fit_KOH.R / predict_KOH.R   # Kennedy–O'Hagan fusion (GP)
│   ├── EI.R                 # Expected improvement
│   ├── project.R            # Main M1/M0/S1/S2 pipeline
│   ├── functions.R          # Test functions (1/2/4/8-D) + low-fidelity versions
│   ├── calibrate.R / run_calibrate.R   # Calibration experiment
│   ├── ablation.R / run_ablation.R     # Ablation experiment
│   ├── fig1.R … fig5.R      # Figure generation
│   └── data/                # RData results from calibration & ablation runs
├── figures/             # SVG/PDF figures (1–5)
├── tex/                 # LaTeX report (report.tex, ref.bib, compiled report.pdf)
├── report_en.md         # Report (English)
├── report_cn.md         # Report (Chinese)
└── README.md
```

## Getting started

The code is written in **R** and requires the [`lhs`](https://cran.r-project.org/package=lhs) package.

```r
# From the codes/ directory
install.packages("lhs")

# Run the calibration experiment
source("run_calibrate.R")

# Run the ablation experiment
source("run_ablation.R")
```

Both experiments cache intermediate results as `.RData` files under `codes/data/`, so re-running with the same parameters skips completed repetitions.

## Reproducibility

- Results are cached in `codes/data/*.RData` (one file per configuration × dimension, plus summary files).
- Test functions cover 1, 2, 4, and 8 dimensions (Joseph's 1-D test, the Branin function, a 4-factor additive function, and the borehole water-flow function), each with a constructed low-fidelity version.
- Budget = 15 high-fidelity equivalents, cost ratio = 20, 20 repetitions per setting.

## Report

- `report_en.md` / `report_cn.md` — the full presentation report in Markdown (English / Chinese).
- `tex/report.pdf` — the compiled LaTeX version.
