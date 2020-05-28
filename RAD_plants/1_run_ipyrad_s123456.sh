#!/bin/bash
#SBATCH -J ipyrad
#SBATCH -n 16
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem-per-cpu=8000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o ipyrad_%A.out # File to which STDOUT will be written

module purge
module load Anaconda/5.0.1-fasrc02
source activate ipyrad_latest

ipyrad --MPI -f -d -c $SLURM_NTASKS -s 1234567 -p params-ref.txt
