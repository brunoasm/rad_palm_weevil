#!/bin/bash
#SBATCH -n 4                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 0-8:00          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p shared,test    # Partition to submit to
#SBATCH --mem=1000           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o bedassle.%a.%A.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -J bedassle

#use array ID to inform species

module load gcc/7.1.0-fasrc01 udunits/2.2.26-fasrc01 R/3.5.1-fasrc02 proj/5.0.1-fasrc01 eigen/3.3.7-fasrc01 geos/3.6.2-fasrc01 gdal/2.3.0-fasrc01 Anaconda

Rscript --no-restore 6-run_bedassle.R
