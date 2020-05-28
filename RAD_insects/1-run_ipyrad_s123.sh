#!/bin/bash
#SBATCH -J ipyrad
#SBATCH -n 12
#SBATCH -N 1
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem-per-cpu=2000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o ipyrad123_%A.out # File to which STDOUT will be written

module purge
module load Anaconda/5.0.1-fasrc02
#source activate ipyrad_latest
source activate ipyrad_v0730

ipyrad --MPI -f -c $SLURM_NTASKS -s 123 -p params-all.txt
#ipyrad --MPI -f -c $SLURM_NTASKS -s 3 -p params-all.txt
