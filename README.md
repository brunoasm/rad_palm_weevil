# Description

This repository contains code used in analyses and to produce figures for the following bioRxiv preprint:

Evaluating species interactions as a driver of phytophagous insect divergence
Bruno A. S. de Medeiros, Brian D. Farrell
bioRxiv 842153; doi: https://doi.org/10.1101/842153

Most of the R code was written as Rmarkdown files, and the html output including results and plots is also provided.

In each folder, scripts are numbered according to the order in which they were used

# Contents

## RAD_insects and RAD_plants

These folders contain parameter files and bash scripts used to assemble datasets with [ipyrad](https://ipyrad.readthedocs.io/en/latest/).

## file_conversion

Custom python scripts used to convert ipyrad output files to nexus and genpop formats, used in analysis for initial species delimitation

## delimiting species

Scripts used in initial delimitation of cryptic weevil species and plot PCA results.

## ANGSD_weevils and ANGSD_plants 

Analyses using [ANGSD](http://www.popgen.dk/angsd/index.php/ANGSD), [PCAngsd](http://www.popgen.dk/software/index.php/PCAngsd) and [NGSdist](https://github.com/fgvieira/ngsDist), including:
* filter sites by Hardy-Weinberg equilibrium using population structure
* estimate genetic distances
* estimate site frequency spectra
* estimate genetic covariance

## bedassle2

Scripts used to run and plot results for cross-validation for model selection as well as the best model in [bedassle2](https://github.com/gbradburd/bedassle).



