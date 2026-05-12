# NMRHealthQuant

NMRHealthQuant is a fully containerized, automated pipeline for the quantification of metabolites and the prediction of clinical biomarkers from serum Nuclear Magnetic Resonance (NMR) spectra. It leverages both 1D NOESY and 2D J-Resolved (J-Res) NMR data to generate comprehensive metabolic profiles.

## Prerequisites
The only requirement to run this pipeline is to have Docker installed on your system. 
* Download Docker Desktop for Windows or Mac (https://www.docker.com/products/docker-desktop/).
* For Linux, use your distribution's package manager (e.g., `sudo apt install docker.io`).

## Installation & Setup

Since the environment is fully dockerized, you just need to build the image from the provided source files. Open your terminal in the directory containing the Dockerfile and run:

docker build -t nmrhealthquant .

(Note: Do not miss the dot `.` at the end of the command).

## Data Directory Structure

The application expects the input directory (referred to as NMR_DATA) to contain standard Bruker NMR data folders. Each subdirectory within NMR_DATA is treated as an individual sample. 

The script dynamically searches inside each sample's subfolders to identify the required experiments based on the pulse sequence recorded in the `acqus` file. The structure should look like this:

```
NMR_DATA/
│
├── Sample_001/                  <- Name of the sample (used in the final report)
│   ├── 10/                      <- Experiment folder (number can be anything, e.g., 10, 1, 30...)
│   │   ├── acqus                <- Must contain the NOESY pulse sequence ('noesygppr1d')
│   │   ├── pdata/
│   │   │   └── 1/               <- Processed 1D spectrum data (1r, procs, etc.)
│   │   └── ...
│   │
│   ├── 12/                      <- Experiment folder (number can be anything)
│   │   ├── acqus                <- Must contain the J-Res pulse sequence ('jresgpprqf')
│   │   ├── ser                  <- Raw data file (used to extract the measurement date)
│   │   ├── pdata/
│   │   │   └── 1/               <- Processed 2D spectrum data (2rr, procs, proc2s, etc.)
│   │   └── ...
│
├── Sample_002/                  <- Next sample
│   ├── ...
```

IMPORTANT REQUIREMENTS:
1. Processed data is mandatory: The tool relies on previously processed data (pdata/1). Make sure the spectra have been processed following the standard Bruker IVDr protocols before running the tool.
2. Dynamic Experiment Detection: The folder numbers for the experiments (e.g., 10, 12) do not matter. The script reads the `acqus` file in each folder to automatically find the NOESY ('noesygppr1d') and J-Resolved ('jresgpprqf') experiments.
3. Missing Data: If a sample folder does not contain both required experiments (processed NOESY and J-Res), the script will automatically skip that sample and continue with the next one.

## Usage

You can run the container in two different ways depending on your needs. Replace /path/to/NMR_DATA with the actual path to your data folder.

### Option A: Standard Run (Recommended)
This generates the CSV and XLSX reports directly inside your NMR_DATA folder.

Linux / macOS:
docker run -v /path/to/NMR_DATA:/home/jovyan/work/data nmrhealthquant

Windows (Command Prompt / PowerShell):
docker run -v //c/path/to/NMR_DATA:/home/jovyan/work/data nmrhealthquant

### Option B: Read-Only Data with Alternate Output
If your source data is protected (read-only) or you prefer to keep the outputs separated, you can mount an alternate output directory. The container automatically detects the /output volume and saves the individual sample files there.

Linux / macOS:
docker run -v /path/to/NMR_DATA:/home/jovyan/work/data:ro -v /path/to/output:/home/jovyan/work/output nmrhealthquant

Windows:
docker run -v //c/path/to/NMR_DATA:/home/jovyan/work/data:ro -v //c/path/to/output:/home/jovyan/work/output nmrhealthquant

### Example (macOS/Linux)
# Generate reports in a separated directory (protecting the source data)
docker run -v "/Users/aibanez/projects/NMR_DATA_test:/home/jovyan/work/data:ro" -v "/Users/aibanez/projects/NMR_DATA_test_out:/home/jovyan/work/output" nmrhealthquant

## Outputs

The pipeline will generate the following files in your target directory (either the NMR_DATA folder or the designated /output folder):

* NMRquantResults.csv: A consolidated CSV file containing the quantified metabolites, predicted clinical biomarkers, and their respective errors for all successfully processed samples.
* NMRquantResults.xlsx: An Excel spreadsheet containing the exact same data as the CSV, provided for easier viewing.
* 000ERRORS.log: A log file created automatically if any sample encounters an error or is skipped during processing. It contains the error traces to help troubleshoot problematic NMR spectra.

Note on permissions: The container automatically checks if the target output directory has write permissions. If the target folder is strictly read-only (which can happen if the source data is protected and no alternate output volume was mounted), the process will safely abort and alert the user to prevent silent failures.
