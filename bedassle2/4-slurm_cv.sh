#!/bin/bash
#SBATCH -n 1                # Number of cores
#SBATCH -N 1                # Ensure that all cores are on one machine
#SBATCH -t 0-0:10          # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p test    # Partition to submit to
#SBATCH --mem=1000           # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o xval_partitions.%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -J xval_partitions

module load gcc/7.1.0-fasrc01 udunits/2.2.26-fasrc01 R/3.5.1-fasrc02 proj/5.0.1-fasrc01 eigen/3.3.7-fasrc01 geos/3.6.2-fasrc01 gdal/2.3.0-fasrc01 Anaconda

#Let's start by creating partitions for cross validation
for SPECIES_ID in `seq 1 13`
do
  export SPECIES_ID
  Rscript --no-restore 4.1-create_partitions.R
done

 #looping through model first avoids file access conflicts
for MODEL_ID in `seq 1 8`
do
  for SPECIES_ID in `seq 1 13`  
  do
    export SPECIES_ID
    export MODEL_ID
    sbatch -n 1 \
           -N 1 \
           -t 4-00:00 \
           -p shared \
           --mem=1000 \
           -o cv.$SPECIES_ID.$MODEL_ID.%A.out \
           -J cv.$SPECIES_ID.$MODEL_ID \
           --wrap 'Rscript --no-restore 4.2-run_cross_validation.R'
  done
done



