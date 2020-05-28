#!/bin/bash

mkdir -p ML_estimates

outfolder=$PWD/ML_estimates

for species in Anchylorhynchus_1 Anchylorhynchus_2 Anchylorhynchus_3 Andranthobius_1 Andranthobius_2 C_decolor_1 C_decolor_2 C_impar D_polyphaga M_bondari_1 M_ypsilon R_rectinasus_1  
do
    echo Doing $species
    cd $species
    for model in model*
    do
        echo $model
        cd $model
        column=$(($(grep -c output *.est) + 2))
        echo "SEARCH_ID" $(head -n 1 ML_SEARCH_1/*/*.best*) > $outfolder/${species}_${model}_ML.txt
        for folder in ML_SEARCH_* ; do echo $folder $(find $folder -name '*.bestlhoods' -exec tail -n 1 {} \;); done | sort -g -k $column >> $outfolder/${species}_${model}_ML.txt
        # in some templates, we used MIGAB and in others MIG12, so need to change:
        sed -i 's/MIG12/MIGAB/' $outfolder/${species}_${model}_ML.txt
        sed -i 's/MIG21/MIGBA/' $outfolder/${species}_${model}_ML.txt  
        cd ..
    done
    cd ..
done
