#!/bin/bash

jupyter nbconvert --to notebook --execute --inplace nmrhealthquant.ipynb --ExecutePreprocessor.kernel_name=python3 --log-level WARN
