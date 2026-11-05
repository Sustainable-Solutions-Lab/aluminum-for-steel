# Code for "Could steel emissions be reduced by substituting aluminum?"

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

Helper functions are in `utils/`:

- `rdylbu.m` is a red-yellow-blue colormap.
- `smooth5.m` is a 5-point moving average.

## Inputs

All model inputs are hard-coded in the scripts. The route-level costs and CO₂ intensities come from Supplementary Tables S1–S3. The historical and projected U.S. electricity prices and grid carbon intensities come from the EIA *Monthly Energy Review* and *Annual Energy Outlook*. Data sources are cited in the paper.
