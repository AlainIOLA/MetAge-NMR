# MetAge paper code

This repository contains the notebook `MetAgePaperCode.ipynb` and a directory named `Docker`. The `Docker` folder includes a pre-configured environment that completely automates the quantification of metabolites and the prediction of clinical biomarkers, without the need to manually install or run the code. Detailed instructions for this tool can be found in its own `README.md` inside the `Docker` folder.

## Prerequisites

To run the notebook, you will need a Python environment with Jupyter installed and the following libraries:

* `numpy`
* `pandas`
* `scipy`
* `nmrglue`
* `scikit-learn`
* `tpot`
* `matplotlib`
* `joblib`
* `shap`

## Required files

The notebook requires the following auxiliary data file to process the spectra:

* `dataPPMS_NOESY.csv`: Contains the reference ppm values required for the processing and calibration of the NOESY spectra.

Ensure that this file is placed in the same directory as the notebook before starting execution.

## Notebook structure and usage

The notebook is organized into sequential blocks containing the following main functions:

### 1. Spectra loading and processing (`load_nmr_spectra`)
This function processes raw Bruker NMR directories. It automatically searches for the appropriate experiment (NOESY or CPMG), applies a baseline correction using Asymmetric Least Squares (AsLS), and calibrates the chemical shift targeting the alanine doublet signal.

### 2. Dimensionality reduction (`bin_spectra`)
It groups consecutive data points (without interpolation) to reduce the dimensionality of the high-resolution spectra to a specific bin size. The resulting matrices are exported automatically.

### 3. Predictive model training (`run_tpot_train`)
This block uses genetic programming via the TPOT library to automatically search and optimize the best regression model pipeline to predict clinical variables, such as age. It exports the best model and its corresponding standard scaler as binary files.

### 4. Model evaluation and execution (`run_model`)
This function handles the evaluation of the predictive models. It integrates the data with the clinical metadata and splits the dataset into training and testing subsets. After performing an optional K-Fold cross-validation to assess the model's robustness, it executes a final training phase. Ultimately, it exports the fully trained model and its corresponding standard scaler as binary files.

### 5. Application to new cohorts and interpretability (`analyze_age_new_sample_shap_stats`)
The `analyze_age_new_sample_shap_stats` function evaluates new datasets against the established reference models (supporting both TPOT and PyTorch pipelines). It first uses a high-precision sampling algorithm to strictly match the chronological age distributions between the reference pool and the new cohort. Once matched, it predicts the metabolic age and categorizes each sample's "metabolic distortion" (accelerated, normal, or decelerated aging), computing robust statistical tests (such as Chi-square, Kolmogorov-Smirnov, and Welch's t-test) to compare the populations. Finally, it performs an in-depth SHAP interpretability analysis, generating summary plots, evaluating the delta of SHAP values between groups, and calculating the Z-score shifts of the original spectral variables to reveal the specific metabolic drivers behind the predictions.
