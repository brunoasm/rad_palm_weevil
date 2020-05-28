#!/bin/bash
#SBATCH -J SFS_ML
#SBATCH -n 8
#SBATCH -N 1
#SBATCH -t 4-00:00:00 # Runtime in D-HH:MM
#SBATCH -p shared,huce_intel # Partition to submit to
#SBATCH --mem 300 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o ML_%a_%A.out # File to which STDOUT will be written

# We estimated the SFS in ANGSD and will use it now to estimate migration between populations in fastsimcoal
# Run this from each OTU/model folder


module load gcc openmpi

# fastsimcoal is in PATH
# make sure there is a tpl and an est file in the folder

mkdir -p ML_SEARCH_$SLURM_ARRAY_TASK_ID
cd ML_SEARCH_$SLURM_ARRAY_TASK_ID
ln -s ../../*.obs ./
ln -s ../*.est ./
ln -s ../*.tpl ./

fsc26 -t *.tpl \
      -e *.est \
      --multiSFS \
      --msfs \
      --cores $SLURM_NTASKS \
      --numBatches 16 \
      --maxlhood \
      -L 300 \
      -n 500000 \
      --seed 6450$SLURM_ARRAY_TASK_ID \
      -q

