#!/bin/bash
#SBATCH -J get_bam
#SBATCH -n 2
#SBATCH -t 0-08:00:00 # Runtime in D-HH:MM
#SBATCH -p test # Partition to submit to
#SBATCH --mem 2G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o get_bam_%A.out # File to which STDOUT will be written

# This script will use ipyrad output to make reference sequences for each locus
# and then call bwa to map reads to this reference




#save ipyrad directory in a variable
export IPYRAD_DIR=../../../../RAD_insects/
export START_DIR=$PWD

#OTUs.txt contains a list of the OTUs we will work on
cat ../OTUs.txt | while read OTU
#for OTU in M_ypsilon #used this line to redo only these after errors
do
    echo Working on $OTU
    #get morphosecies name
    morphosp=$(echo $OTU | sed 's/_[0-9]$//g')
    
    #create directory for OTU
    mkdir -p $OTU
    cd $OTU
    #create directory for bamfiles
    mkdir -p bamfiles
    cd bamfiles


    echo Retrieving consensus for each locus
    #get consensus sequences for loci for species
    module load python
    source activate UPP
    python ../../loci2consensus.py $IPYRAD_DIR/${morphosp}_outfiles/$morphosp.loci reference.fasta
    source deactivate UPP
    module purge

    echo Making bwa index
    #now let's index the reference file with bwa
    module load bwa/0.7.15-fasrc02 samtools/1.5-fasrc02 
    bwa index -p $morphosp reference.fasta

    #and map using bwa:
    #samples.txt contains records of OTU,sample,pop so we can use grep to filter OTUs and cut to get sample
    cat ../../../samples.txt | grep $OTU | cut -d , -f 2 | while read sample
    do 
        echo WORKING ON $sample
        echo mapping
        # see https://informatics.fas.harvard.edu/whole-genome-resquencing-for-population-genomics-fastq-to-vcf.html#preprocess
        bwa mem -M -t $SLURM_NTASKS -R "@RG\tID:${sample}\tSM:${sample}\tPL:ILLUMINA\tLB:${sample}_LIB" \
                    $morphosp $IPYRAD_DIR/all_edits/${sample}.trimmed_R1_.fastq.gz > ${sample}_bwa.sam

        echo sorting and indexing
        #now let's sort and index sam files
        samtools sort -o $sample.bam ${sample}_bwa.sam
        samtools index $sample.bam
    done
    
    cd $START_DIR
done
