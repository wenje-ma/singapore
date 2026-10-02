# Research on Multi-Fidelity Data-Based Optimization Algorithms

Research project on **multi-fidelity Bayesian optimization** — optimizing an expensive black-box function when two evaluation channels are available: a cheap low-fidelity simulator with systematic bias, and an accurate but expensive high-fidelity simulator. Under an extremely small budget (15 high-fidelity equivalents), the project assembles a pipeline of experimental-design components and ablates each one to quantify its contribution.

- **Author:** Wenje Ma — Beijing Institute of Technology, Mathematics and Applied Mathematics (Qiangji Program), 2024
- **Advisor:** Dianpeng Wang

## Overview

The design parameters live in $\boldsymbol{x}\in[0,1]^{p}$, and the simulator is a black box $y=h(\boldsymbol{x})$. Two evaluation channels are available:

| Channel | Cost | Accuracy |
| --- | --- | --- |
| Low-fidelity $h_\mathrm{L}(\boldsymbol{x})$ | cheap, $c_\mathrm{L}$ | systematic bias |
| High-fidelity $h_\mathrm{H}(\boldsymbol{x})$ | expensive, $c_\mathrm{H} \gg c_\mathrm{L}$ | accurate |

The bias between the two fidelities is unknown. The formal goal is

$$\widehat{\boldsymbol{x}}\approx\argmin_{\boldsymbol{x}\in[0,1]^{p}}h_\mathrm{H}(\boldsymbol{x}),$$

found as accurately as possible under a total budget of **15 high-fidelity evaluations**.

## Pipeline

The full pipeline **M1** combines four experimental-design components:

```
MaxPro design → Sequential design → Nested (multi-fidelity) design → Expected improvement
```

To attribute each component's contribution, three control configurations are tested:

- **M0** — blank control: MaxPro design → Expected improvement
- **S1** — M1 without the nested (fusion) design
- **S2** — M1 without the sequential design

### Key findings

- **Fusion is the decisive component:** in 1-D it turns outright failure into feasibility and reaches the global optimum; in 2-D it approaches the Branin optimum; its value decays with dimension and fails in 8-D.
- **Screening never helps — it even hurts:** the bias between low and high fidelity makes factor-importance ranking unreliable; removing the screening step improves results.
- **High dimensions set the ceiling:** at 8 dimensions fusion stops working — the curse of dimensionality inside the multi-fidelity framework.
- Under the same budget, a few high-fidelity points **with** fusion far outperform many high-fidelity points alone.

## Repository structure

```
singapore/
├── codes/                  # R implementation of the pipeline
│   ├── maxpro_design.R         # Maximum projection design
│   ├── mofat_design.R          # Max one-factor-at-a-time design with projection
│   ├── nested_design.R         # Nested (multi-fidelity) design
│   ├── fit_KOH.R / predict_KOH.R   # Kennedy–O'Hagan fusion (Gaussian process)
│   ├── EI.R                    # Expected improvement
│   ├── project.R               # Main M1 / M0 / S1 / S2 pipeline
│   ├── functions.R             # Test functions (1/2/4/8-D) + low-fidelity versions
│   ├── calibrate.R / run_calibrate.R   # Calibration experiment
│   ├── ablation.R  / run_ablation.R    # Ablation experiment
│   ├── fig2.R … fig6.R         # Figure generation (fig1 is a portrait, not a plot)
│   └── data/                   # Cached .RData results
├── figures/                # Figures 1–6 (fig1 = V. Roshan Joseph portrait; fig2–6 = design/results)
├── tex/                    # Quarto / Beamer slides and presentation materials
│   ├── report.qmd             # Beamer slides (metropolis theme) → report.pdf
│   ├── booklet.qmd             # A5 cue-card booklet (keyword page + spoken script) → booklet.pdf
│   ├── speak.md               # Full spoken script
│   └── keys.md                # Keyword cue cards
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
- Budget = 15 high-fidelity equivalents, cost ratio = 20, 20 repetitions per setting; success is the **median** best value across the 20 runs (lower is better).

## Slides and presentation

- `tex/report.qmd` → `tex/report.pdf` — the Beamer presentation (metropolis theme).
- `tex/booklet.qmd` → `tex/booklet.pdf` — the A5 cue-card booklet used while presenting.
- `tex/speak.md` — the full spoken script; `tex/keys.md` — the keyword cue cards.
