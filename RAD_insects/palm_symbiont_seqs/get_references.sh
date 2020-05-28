# first, let's get consensus sequences for Syagrus:
zcat ~/labdir/working/Syagrus_coronata_phylogeography/ipyrad_assembly/denovoref_consens/BdM*.gz | gzip > Syagrus_consensus.fasta.gz

# now, the coconut genome. In this case, we will just create a link to save disk space
ln -sf ~/labdir/working/Syagrus_coronata_phylogeography/reference_genome/CoConut.genome.fa.gz ./

# bacterial genomes were manually downloaded from NCBI with the help of Geneious

# finally, we use awk to rename all sequences to make sure that they have different names and will not cause problems for bwa
zcat *.gz | awk '/^>/{gsub(/ /,"_",$0); print $0 "_" NR; }!/^>/{print $0}' > all_references.fasta
 
