cat *.txt | while read samp
do ln -s /n/home08/souzademedeiros/labdir/working/RAD/all_samples_concat/${samp}_R1_.fastq.gz ./
done
