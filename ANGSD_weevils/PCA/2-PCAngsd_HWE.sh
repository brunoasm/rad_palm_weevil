#!/bin/bash
#SBATCH -J hwe
#SBATCH -n 2
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem 10000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o hwe_%A.out # File to which STDOUT will be written

# We will use ANGSD to generate PCA plots, which we will use to calculate population distances

module load python
source activate pcangsd
export PCA_PATH=/n/home08/souzademedeiros/programs/pcangsd

cat ../OTUs.txt | while read OTU
#for OTU in M_ypsilon #used this line to redo only these after errors
do
    echo working on $OTU
    cd $OTU
    nsamp=$(cat bam.filelist | wc -l)
    maf=$(bc <<< "scale=2; 1/$nsamp")
    python $PCA_PATH/pcangsd.py -beagle 1st_pass*.beagle.gz  \
           -minMaf $maf -inbreedSites -threads $SLURM_NTASKS -sites_save -o hwe

    python ../filtersites.py
    cut -f 1 include_sites.txt | sort | uniq > include_chrs.txt
    cd ..
done
