# Code for "The key to reducing steel emissions may be using aluminum instead"

Samuel Faucher, Steven J. Davis, Juan B. García Martínez, Ian McKay

This repository contains the MATLAB code that generates Figures 2–4 and Supplementary Figure 1 of the paper. It covers the techno-economic and emissions model for five primary metal routes, the CO₂ abatement-cost maps, and the aluminum–steel substitution model. The equations are documented in the Supplementary Information.

## Requirements

- MATLAB R2018b or later. No toolboxes are needed.
- The code is not compatible with GNU Octave.

## Quick start

From the repository folder, run:

```matlab
run_all
```

This runs every figure script and saves each figure window to `figures/` as PNG (300 dpi) and PDF. `figure3_abatement_costs` also prints the 2050 abatement costs quoted in the text (aluminum ≈ $9/t CO₂, steel ≈ $363/t CO₂).

Each script can also be run on its own. First call `addpath('utils')`.

## Scripts and figures

Each script opens several MATLAB figure windows. Only some of them appear in the paper; the others are diagnostic or exploratory outputs of the same model.

| Script | Paper figure | MATLAB figure no. | Other windows |
|---|---|---|---|
| `figure2_costs_and_intensities.m` | Fig. 2a, 2b | 1 → 2a; 2 → 2b | — |
| `figure3_abatement_costs.m` | Fig. 3a–d | 1 → 3a; 2 → 3b; 6 → 3c, 3d | 3–5: cost, CO₂ and cost/CO₂ differences by route |
| `figure4a_substitution_ratio.m` | Fig. 4a | 1 | — |
| `figure4b_price_history.m` | Fig. 4b | 2 | 1: earlier version of the substitution-ratio plot |
| `figure4c_production_vs_electricity.m` | Fig. 4c | 1 | — |
| `figure4d_emissions_and_pies.m` | Fig. 4d | 1 → heatmap; 3 → pie charts | 2, 4–6, 10: exploratory |
| `figureS1_green_steel_premium.m` | Supp. Fig. 1 | 1 | — |

Helper functions are in `utils/`:

- `rdylbu.m` is a red-yellow-blue colormap.
- `smooth5.m` is a 5-point moving average.

## Inputs

All model inputs are hard-coded in the scripts. The route-level costs and CO₂ intensities come from Supplementary Tables S1–S3. The historical and projected U.S. electricity prices and grid carbon intensities come from the EIA *Monthly Energy Review* and *Annual Energy Outlook*. Data sources are cited in the paper.

## Changes from the original code

The scripts are the original analysis code, renamed by figure. Model logic, parameters and data are unchanged. The only edits were needed to make the code run from a clean MATLAB installation:

| File (original name) | Change |
|---|---|
| All | Renamed by figure; function names updated to match. Semicolons added to suppress console printing of handles and arrays. |
| `figure3_abatement_costs.m` (`figure3_v3.m`) | Fixed a size-mismatch error at the end of the script: the 1973–2050 time series has 79 rows, not 78. Removed `clear all`. The script now prints the 2050 abatement costs. |
| `figure3_abatement_costs.m`, `figure4d_emissions_and_pies.m` (`fourfutures12_fig4.m`) | Replaced the third-party `brewermap(100,'RdYlBu')` with `utils/rdylbu.m`, which uses the same ColorBrewer colors. |
| `figure4d_emissions_and_pies.m` | Replaced the third-party `linspecer(4)` with a fixed 4-color palette (exploratory window 10 only). The pie charts are now drawn as separate panels; the original loop drew them on one set of axes, so only the last was kept. |
| `figure4b_price_history.m` (`figure4_v1.m`) | Replaced `smooth` (Curve Fitting Toolbox) with `utils/smooth5.m`, which implements the same default 5-point moving average. |
| `figure4a_substitution_ratio.m` (`metals_substitutionratio_new_AP.m`) | Converted from a script to a function. Removed `clear all`/`clc`. Tick positions are read with `get()` instead of dot indexing (same result). |
| `figure4c_production_vs_electricity.m` (`figure4_substitution_v2.m`) | Prints the cross-price elasticities used for the three curves. |
| `figure2_costs_and_intensities.m` (`figure2_v1.m`), `figure3_abatement_costs.m` | Replaced `clim` (R2022a+) with the equivalent `caxis`, so the code runs on R2018b+. |
| `figureS1_green_steel_premium.m` (`steelgreenpremium.m`) | Renamed only. |

## License

[To be added]

## Citation

[To be added once published]
