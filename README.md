# Singapore — Multi-Fidelity Bayesian Optimization

> **Research on Multi-Fidelity Data-Based Optimization Algorithms** — an ablatable R pipeline for optimizing expensive black-box functions when a cheap-but-biased low-fidelity simulator and an accurate-but-expensive high-fidelity simulator are both available, under a budget of only **15 high-fidelity-equivalent evaluations**.

**Author:** Wenje Ma (School of Mathematics and Statistics, Beijing Institute of Technology; Mathematics Qiang-Ji Program, 2024) · **Advisor:** Dianpeng Wang

## The pipeline

**M1 (main pipeline):**

```
Maximum Projection design → Sequential design → Nested (multi-fidelity) design → Expected Improvement
```

with three ablation controls:

- **M0** — MaxPro design → EI (no multi-fidelity machinery at all);
- **S1** — nested design removed (no fusion);
- **S2** — sequential stage removed.

Test functions: 1/2/4/8-dimensional suites (Joseph's 1-D function, Branin, a 4-factor additive function, the borehole flow model), each paired with a constructed biased low-fidelity version. Budget = 15 high-fidelity-equivalent evaluations at a 20:1 cost ratio; 20 repetitions per setting; median best-value reported.

## Key findings

1. **Fusion (the nested design) is the decisive component.** It rescues a failing run in 1-D, approaches the Branin optimum in 2-D — and fails at 8-D (the curse of dimensionality inside the multi-fidelity framework).
2. **Screening never helped.** The low↔high fidelity bias makes factor-importance rankings unreliable, so screening was at best useless and sometimes harmful.
3. **Under the same budget, few high-fidelity points *with fusion* beat many high-fidelity points alone.**

## Repository structure

```
singapore/
├── codes/
│   ├── project.R            # Main pipeline (M1 / M0 / S1 / S2)
│   ├── maxpro_design.R      # Maximum projection design
│   ├── nested_design.R      # Nested multi-fidelity design
│   ├── fit_KOH.R / predict_KOH.R   # Kennedy–O'Hagan autoregressive GP fusion
│   ├── EI.R                 # Expected improvement
│   ├── functions.R          # Test functions + low-fidelity versions
│   ├── calibrate.R / run_calibrate.R   # Calibration experiments
│   ├── ablation.R / run_ablation.R     # Ablation experiments
│   ├── fig2.R … fig6.R      # Figure scripts
│   ├── DESCRIPTION          # R-style project description (deps: lhs, SFDesign, MOFAT, rkriging)
│   └── data/                # 23 cached .RData results (calibration d1–d8, ablations, summaries)
├── figures/                 # Report figures (PDF + SVG)
├── tex/
│   ├── report.qmd → report.pdf   # Final slides (Beamer, Metropolis theme)
│   ├── booklet.qmd → booklet.pdf # A5 prompt-card booklet
│   └── speak.md / keys.md        # Chinese speaking notes & keyword cards
├── notice.md                # (Chinese) travel checklist for the Singapore visit
└── singapore.png
```

## Reproducing

Run the R scripts in `codes/` (requires `lhs`, `SFDesign`, `MOFAT`, `rkriging`). Cached `.RData` results in `codes/data/` let figures be regenerated without re-running the expensive experiments. Presentations are compiled with Quarto (`quarto render tex/report.qmd`).

## Related repositories

Built on the tooling reproduced in [ed4dse](https://github.com/wenje-ma/ed4dse) and grounded in the theory notes in [dace](https://github.com/wenje-ma/dace). Full list on the [profile page](https://github.com/wenje-ma).
