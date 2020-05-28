#!/bin/bash
#SBATCH -J fold_SFS
#SBATCH -n 1
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p serial_requeue,test # Partition to submit to
#SBATCH --mem 4G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o fold_SFS_%A.out # File to which STDOUT will be written

# This script will get unfolded SFSs inferred in ANGSD and fold them using dadi

#save ipyrad directory in a variable
module load Anaconda
source activate dadi

#OTUs.txt contains a list of the OTUs we will work on
#cat OTUs.txt | while read OTU
for OTU in Anchylorhynchus_3 #use this line instead to redo only a few SFS if needed
do
    echo Working on $OTU
    mkdir -p $OTU
    # let's make a temporary file with SFS in dadi format
    # number are allele counts + 1, so 2*Nweevils + 1
    rm -f $OTU/SFS_temp.dadi
    wc -l ../ANGSD_weevils/PCA/${OTU}/pop*.filelist | \
          head -n -1 | \
          sed 's/^ *//g' | \
          cut -f 1 -d " " | while read N
              do
              echo "1 + 2 * $N" | bc | awk 'BEGIN{ORS=" "};{print $0} '>> $OTU/SFS_temp.dadi
              done
    echo '' >> $OTU/SFS_temp.dadi
    cat ../ANGSD_weevils/PCA/${OTU}/${OTU}_DSFD.obs >> $OTU/SFS_temp.dadi

    #now let's run dadi
    python 0.1-dadi_fold.py $OTU/SFS_temp.dadi $OTU/SFS_folded.temp
    
    #and reformat output to fastscimcoal format
    pop_sizes=$(head -n 1 $OTU/SFS_temp.dadi | tr " " "\n" | xargs -I {} echo {} - 1 | bc )
    npop=$(echo $pop_sizes | wc -w)

    echo 1 obs >  $OTU/${OTU}_MSFS.obs
    echo $npop $pop_sizes >> $OTU/${OTU}_MSFS.obs
    cat $OTU/SFS_folded.temp | sed -n '2p' >> $OTU/${OTU}_MSFS.obs 
    #rm $OTU/SFS_folded.temp $OTU/SFS_temp.dadi
done
