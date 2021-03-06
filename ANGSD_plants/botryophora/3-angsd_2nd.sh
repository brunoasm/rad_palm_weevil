#!/bin/bash
#SBATCH -J angsd
#SBATCH -n 1
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem 10G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o angsd_%A.out # File to which STDOUT will be written

#See comments on ANGSD_weevils folder for explanation on what this script does 

module load angsd/0.920-fasrc01 samtools

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
angsd	-nThreads $SLURM_NTASKS \
	-GL 2 \
	-doGlf 2 \
	-doMaf 1 \
	-doMajorMinor 1 \
	-minMapQ 20 \
	-minQ 20 \
	-SNP_pval 1e-6 \
	-bam bam.filelist \
	-uniqueOnly 1 \
        -remove_bads 1 \
        -rf include_chrs.txt \
	-out syagrus



