#!/bin/bash
#SBATCH -J SFS
#SBATCH -n 8
#SBATCH -t 7-00:00:00 # Runtime in D-HH:MM
#SBATCH -p shared,huce_cascade # Partition to submit to
#SBATCH --mem 5G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o SFS_%A.out # File to which STDOUT will be written

# We will use ANGSD to generate site freqnecy spectra
# As pointed out here, ANGSD does not properly fold site frequency spectra:
# https://github.com/ANGSD/angsd/issues/78
# Therefore, we will infer the unfolded spectra with an arbitrary reference and then fold it using other software

#module load angsd/0.920-fasrc01 samtools
module load angsd/0.930-fasrc01 samtools

#we will loop through all OTUs
#cat ../OTUs.txt | while read OTU
for OTU in Anchylorhynchus_3 #use this line to redo if needed 
do
    echo Working on $OTU
    cd $OTU
    # list all populations
    pops=$(grep $OTU ../../samples.txt | cut -d , -f 3 | sort | uniq)
    
   
    for pop in $pops
    do
        samples=$(grep $OTU ../../samples.txt | grep -E ",$pop$" | cut -d , -f 2)
         # make bam files per population
        rm pop$pop.bam.filelist
        for samp in $samples; do find ./bamfiles -name '*'${samp}'*'.bam >> \
                                                 pop$pop.bam.filelist; done
        # calculate saf from genotype probabilities
        cd bamfiles
	samtools faidx reference.fasta #for some reason, angsd complains if the file is old
        cd ..
	angsd -bam pop$pop.bam.filelist \
              -GL 2 \
              -nThreads 1 \
              -anc bamfiles/reference.fasta \
              -dosaf 1 \
              -fold 0 \
              -minMapQ 30 \
              -minQ 20 \
              -uniqueOnly 1 \
              -remove_bads 1 \
              -rf include_chrs.txt \
              -out pop$pop
    done
        
    # now let's calculate the site frequency spectrum
    realSFS pop*.saf.idx -P $SLURM_NTASKS > ${OTU}_DSFD.obs 
    cd ..
done

echo DONE
