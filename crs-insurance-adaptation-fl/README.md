# CRS, Insurance, and Coastal Adaptation in Florida

This repository is a reproducible research pipeline to estimate the causal effect of FEMA Community Rating System (CRS) participation/score changes on insurance market outcomes (premiums, policy counts, cancellations), and to provide a clearly-labeled policy extrapolation section.

## Quick start
1. Put raw data into `data/raw/` (see `docs/data_dictionary.md`).
2. Configure local paths in `config/paths.yaml`.
3. Run the pipeline:

```bash
make all
```

## Outputs
- Tables: `outputs/tables/`
- Figures: `outputs/figures/`
- Run index + manifest: `outputs/report/`

## Repository layout
- `src/01_ingest/`: ingest raw data → `data/interim/`
- `src/02_clean/`: clean + standardize → `data/processed/`
- `src/03_build/`: build analysis dataset
- `src/04_models/`: regressions producing Tables 1–6
- `src/05_figures/`: Figures 1–3
- `src/06_policy/`: Table 7 policy simulation

