#!/bin/bash
#SBATCH -J angsd
#SBATCH -n 1
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem 10G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o angsd_%A.out # File to which STDOUT will be written
# We will use ANGSD to generate PCA plots, which we will use to calculate population distances

module load GCC/8.2.0-2.31.1 angsd/0.920-fasrc01 gsl/2.6-fasrc01


t seems threading does not really speed up angsd, so we will run in only one core 

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
	-minMapQ 20 \
	-minQ 20 \
        -doSaf 1 \
        -anc bamfiles/reference.fasta \
	-bam bam.filelist \
	-uniqueOnly 1 \
        -remove_bads 1 \
        -rf include_chrs.txt \
	-out syagrus

sum_nums=$(realSFS -P $SLURM_NTASKS syagrus.saf.idx | sed 's/ /+/g')

sites=$(echo ${sum_nums::-1} | bc | awk '{print int($1+0.5)}')
snps=$(cat pca.post.beagle | tail -n +2 | wc -l)
nind=$(\ls bamfiles/*.bam | wc -l)

gzip -c pca.post.beagle > pca.post.beagle.gz #for some reason, ngsDist cannot parse unless zipped
ngsDist --geno pca.post.beagle.gz \
        --n_ind $nind \
        --n_sites $snps \
        --tot_sites $sites \
        --labels bam.filelist \
        --probs \
        --avg_nuc_dist \
        --evol_model 0 \
        --n_threads $SLURM_NTASKS \
        --out syagrus_dists.txt

        
