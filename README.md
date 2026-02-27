# Graduate Student Project Archive

This repository contains selected graduate-level research projects across macroeconomics, environmental economics, and microeconomic theory.

Some projects are complete historical submissions. Others are actively being revised, expanded, or migrated into more structured research pipelines. Where relevant, original papers are included alongside the code used to generate results.

---

## Work in Progress Disclaimer

Parts of this repository are under active revision and expansion.

In particular, the Python-based macroeconomic modeling work represents a structured continuation and generalization of an earlier FRED Endogenous Growth Model project completed in a macroeconomic theory course with Professor Betz R.

The current structure reflects a transition from course-based modeling toward a modular environmental macroeconomic research framework integrating FRED and NOAA data.

---

# Project Structure

## Python – FRED Environmental Macroeconomic Models

**Status:** WIP

This folder contains Python-based time series and macroeconomic modeling work built around structured data pipelines. This is an expansion off from coursework with Professor Aaron Betz.

### What the Code Does

The code in this folder is organized around building reusable pipelines and model-ready datasets. In general, it:

- Pulls macroeconomic time series from FRED (via API)
- Pulls environmental time series from NOAA (currently focused on NOAA CO-OPS water level stations)
- Stores raw pulls locally (raw data is not tracked in git)
- Cleans, validates, and standardizes time series into consistent formats
- Aggregates high-frequency NOAA data (e.g., 6-minute observations) into analysis-ready time scales (e.g., hourly/daily/monthly)
- Merges FRED macro series with NOAA-derived environmental series into a combined modeling dataset
- Supports chunked downloading, retries, and basic error handling for API pulls
- Produces processed datasets intended for downstream modeling and econometric analysis

### Data Sources

- **FRED**: Macroeconomic time series (multiple series, pulled via API)
- **NOAA (CO-OPS)**: Water level station metadata and observational water level time series

### Notes

This folder is a work in progress and reflects an expansion of an earlier endogenous growth modeling project into a broader environmental macro framework.

---


## R Studio – Green Funding and Carbon Dynamics in South Africa

**Status:** Complete Historical Project (Paper + Code Included)

This project was developed in a time series econometrics course with Professor Cornwall.

### Research Question

Does increased “green” funding in South Africa correspond to measurable changes in carbon emissions or trade dynamics?

### Data Sources

- NOAA monthly mean global CO₂ (marine surface sites)  
- IMF Consumer Price Index (CPI)  
- IMF Direction of Trade Statistics (DOT)  
- IMF Commodity export/import indices  

### Methods

The project follows a structured time series workflow:

1. Stationarity Testing  
   - Augmented Dickey-Fuller (ADF)  
   - Autocorrelation Function (ACF)  
   - Visual inspection  
   - Standard deviation rule-of-thumb checks  
   - All variables were found to be I(1)  

2. Univariate ARIMA Modeling  
   - Best-fitting ARIMA specifications selected using BIC  

3. Cointegration Analysis  
   - Johansen test  
   - Engle-Granger two-step method  
   - Cointegrating relationships identified between:  
     - Direction of Trade and Exports  
     - Direction of Trade and Imports  

4. VAR Modeling  
   - Lag selection via Schwarz Criterion  
   - VAR(2) specification  
   - Impulse response functions  
   - Forecast error variance decomposition  

### Core Findings

- CO₂ exhibited limited dynamic response to shocks in trade or price variables.  
- Imports and exports showed stronger dynamic interdependence.  
- Impulse responses were generally small in magnitude.  
- CO₂ did not demonstrate persistent feedback relationships with trade variables within the VAR framework.  

The full paper and code used to generate tables and figures are included in this folder.

---

## Stata – Coastal Resiliency and Insurance Markets (South Florida)

**Status:** Completed Project (Data preview only)

This folder contains Stata scripts that construct a county-level insurance market dataset for South Florida.

### What the Code Does

The code:

- Imports multiple county-level insurance summary reports (CSV format)
- Cleans and standardizes dates, numeric fields, and categorical variables
- Renames raw reporting fields into structured insurance metrics
- Constructs policy, premium, exposure, cancellation, and transfer measures
- Generates a premium-per-policy variable
- Appends all counties into a unified panel-style dataset
- Adds a county-level sea level exposure proxy (percent of population below 4 ft above mean sea level)
- Outputs a master dataset ready for econometric analysis

### Data Sources

- County-level insurance market summary reports (QSR files)
- County sea level exposure estimates (2010 Census–based values)

### Dataset Documentation

A PDF explaining the dataset structure, variable definitions, and selection rationale is included in this folder.
