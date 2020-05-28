#!/bin/bash
#SBATCH -J angsd
#SBATCH -n 1
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem 10G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o angsd_%A.out # File to which STDOUT will be written

# We will use ANGSD for PCA and sife frequency spectra, but before we need to filter out potentially paralogous sites
# Some of them were filtered during assembly with ipyrad, but site frequency spectra still show a lot of heterozygotes
# For this reason, for each morphospecies, we will loop through populations and generate SNP statistics
# We will then filter out sites that fail the HWE in any population
# In this script, we will just do the statistics

module load angsd/0.930-fasrc01 samtools

#we will loop through all OTUs
cat ../OTUs.txt | while read OTU
#for OTU in M_ypsilon #used this line to redo only these after errors
do
    cd $OTU
    # create bam file list
    find ./bamfiles -name '*.bam' > bam.filelist

    # it seems threading does not really speed up angsd, so we will run in only one core 

    # run angsd to obtain genotype likelihoods
    # options used:
    # -nThreads		number of threads
    # -GL 2			use GATK for genotype likelihoods
    # -doGlf 2		create an output file in beagle format
    # -doMaf 1		both major and minor alleles assumed to be known
    # -doMajorMinor 1	infer major and minor alleles from genotype likelihoods
    # -SNP_pval 1e-6	filter only to SNPs with p-value less than 1e-6
    # -dosnpstat 1		calculate SNP statistics to enable filtering
    # -uniqueOnly 1		only use reads mapping to unique location
    # -bam bam.filelist	input file
    # -out g_likelihoods	root of output file 
    angsd   -nThreads $SLURM_NTASKS \
            -GL 2 \
            -doGlf 2 \
            -doMaf 1 \
            -doMajorMinor 1 \
            -doGeno 2 \
            -doPost 1 \
            -postCutoff 0.5 \
            -doCounts 1 \
            -doDepth 1 \
            -maxDepth 1000 \
            -minMapQ 30 \
            -minQ 20 \
            -doHWE 1 \
            -SNP_pval 1e-6 \
            -dosnpstat 1 \
            -bam bam.filelist \
            -remove_bads 1 \
            -uniqueOnly 1 \
            -out 1st_pass_$OTU
    cd ..
done
