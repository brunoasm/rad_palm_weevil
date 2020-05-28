#!/bin/bash
#SBATCH -J ipyrad
#SBATCH -n 8
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test,shared # Partition to submit to
#SBATCH --mem-per-cpu=1000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o ipyrad4567_%a_%A.out # File to which STDOUT will be written

# Use job array number to select morphospecies to run

module purge
module load Anaconda/5.0.1-fasrc02
source activate ipyrad_latest

morphosp=$(cat morphospecies.txt | cut -d ' ' -f $SLURM_ARRAY_TASK_ID)

ipyrad --MPI -f -c $SLURM_NTASKS -s 4567 -p params-${morphosp}.txt
