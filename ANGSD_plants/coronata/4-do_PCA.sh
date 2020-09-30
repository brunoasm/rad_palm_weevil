#!/bin/bash
#SBATCH -J pcangsd
#SBATCH -n 2
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem 10000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o pcangsd_%A.out # File to which STDOUT will be written

#See comments on ANGSD_weevils folder for explanation on what this script does 

module load python
source activate pcangsd
export PCA_PATH=/n/home08/souzademedeiros/programs/pcangsd

nsamp=$(cat bam.filelist | wc -l)
maf=$(bc <<< "scale=2; 1/$nsamp")
python $PCA_PATH/pcangsd.py -beagle syagrus.beagle.gz -minMaf $maf -post_save -threads $SLURM_NTASKS -geno 0.8 -o pca

