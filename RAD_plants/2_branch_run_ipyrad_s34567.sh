#!/bin/bash
#SBATCH -J ipyrad
#SBATCH -n 16
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem-per-cpu=4000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o ipyrad_%A.out # File to which STDOUT will be written
#SBATCH --contiguous

module purge
module load python/2.7.14-fasrc01
source activate ipyrad_latest

ipyrad -f -p params-ref.txt -b denovoref

sed -i '7s/^reference/denovo/' params-denovoref.txt

ipyrad --MPI -c $SLURM_NTASKS -p params-denovoref.txt -f -s 34567

