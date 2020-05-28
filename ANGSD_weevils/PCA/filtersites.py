#!/usr/bin/env python

# Created by Bruno de Medeiros Mar 2020
# This script opens LRT results from PCA ANGSD
# and outputs loci for which all sites pass HWE test with pvalue < 1e-5
# we will then use these sites to run ANGSD again

import numpy as np 
from scipy.stats import chi2

lrt = np.load('hwe.lrt.sites.npy')

pvalue = 0.05
lrt_threshold = chi2.ppf(1-pvalue,1)
filtered = [i for i,x in enumerate(lrt) if x > lrt_threshold]

all_sites = open('hwe.sites','r')

loci_filtered = set()
locsit = []
for i,s in enumerate(all_sites):
    locsit.append(s.split('_'))
    if i in filtered:
        loci_filtered.add(locsit[-1][0])

all_sites.close()

outf = open('include_sites.txt','w')
for x in locsit:
    if x[0] not in loci_filtered:
        outf.write('\t'.join(x))
        
outf.close()
all_sites.close()

print('Loci filtered:')
print(sorted([int(x) for x in loci_filtered]))
