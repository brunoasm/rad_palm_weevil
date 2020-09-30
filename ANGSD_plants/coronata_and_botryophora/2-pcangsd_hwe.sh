#!/bin/bash
#SBATCH -J hwe
#SBATCH -n 2
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem 10000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o hwe_%A.out # File to which STDOUT will be written

#See comments on ANGSD_weevils folder for explanation on what this script does 

module load python
source activate pcangsd
export PCA_PATH=/n/home08/souzademedeiros/programs/pcangsd

nsamp=$(cat bam.filelist | wc -l)
maf=$(bc <<< "scale=2; 1/$nsamp")
python $PCA_PATH/pcangsd.py -beagle g_likelihoods.beagle.gz  \
       -minMaf $maf -inbreedSites -threads $SLURM_NTASKS -sites_save -o hwe

python filtersites.py
cut -f 1 include_sites.txt | sort | uniq > include_chrs.txt

