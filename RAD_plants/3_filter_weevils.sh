#!/bin/bash
#SBATCH -J ipyrad
#SBATCH -n 8
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem-per-cpu=4000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o ipyrad_%A.out # File to which STDOUT will be written

module purge
module load python/2.7.14-fasrc01
source activate ipyrad_latest

#############
#commented out parts were already run
############


#branch and remove samples with few loci or other species of Syagrus
ipyrad -f -p params-denovoref.txt -b denovoref_BEDASSLE_weevils - BdM1597 BdM2130 BdM2132 BdM2133 BdM1703 BdM1627 BdM1704 BdM2174 

#set minimum number of samples in a locus to 30
sed -i '23s/4 /30/g' params-denovoref_BEDASSLE_weevils.txt
sed -i 's/p, s, v/\*/g' params-denovoref_BEDASSLE_weevils.txt

ipyrad -c $SLURM_NTASKS -p params-denovoref_BEDASSLE_weevils.txt -f -s 7
