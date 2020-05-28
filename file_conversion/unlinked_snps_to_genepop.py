#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
This script produces a genpop file from a phylip file in which columns are unlinked snps
If desired, a file with population assignments can be provided (following the same format as ipyrad's population assignment file) 
written by B. de Medeiros, starting in 2015
parts of the code were based on pyrad source code
'''
import argparse
import pandas
import os
from cStringIO import StringIO
from collections import defaultdict

def to_genpop(amb):
    amb = amb.upper()
    " returns bases from ambiguity code in genpop format"
    D = {"R":"003001",
         "K":"003004",
         "S":"003002",
         "Y":"004002",
         "W":"004001",
         "M":"002001",
         "A":"001001",
         "T":"004004",
         "G":"003003",
         "C":"002002",
         "N":"000000",
         "-":"000000"}
    return D.get(amb)


#first, parse arguments
parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-u', '--unlinked-snps', help = 'path to *.unlinked_snps file')
parser.add_argument('-p', '--popfile', help = 'path to population assignment file in pyrad format')
parser.add_argument('-t', '--table', help = 'path to csv table with population information')
parser.add_argument('-s', '--sample-field', help = 'name of column with sample names in csv table', default = 'sample')
parser.add_argument('-g', '--population-field', help = 'name of column with population names in csv table', default = 'population')
parser.add_argument('-a', '--append-pop-names', help = 'whether to append population names to sample names', action = 'store_true')
parser.add_argument('-f', '--filter', help = 'filter loci to only those found across all populations', action = 'store_true')

args = parser.parse_args()

if args.popfile is not None and args.table is not None:
    raise Exception('Provide either popfile or table, not both.')

unlinked_snps = args.unlinked_snps
outpath = os.path.basename(unlinked_snps).split(".")[0] + ".gen"




## read in data from unlinked_snps to sample names
with open(unlinked_snps,'r') as infile:
    dat = infile.readlines()
    ## read SNPs
    sites = []
    samples = []
    for line in range(len(dat[1:])):
        samples.append(dat[1:][line].split()[0])
        sites.append(dat[1:][line].split()[1])
    nsites = len(sites[0])
    sites = '\n'.join(sites)
    

## save information in a pandas table
snps_table = pandas.read_fwf(StringIO(sites), widths=[1] * nsites, header=None)
snps_table.set_index(pandas.Series(samples), inplace = True)

###parse population assignment
if args.popfile:
    with open(args.popfile, 'r') as pop_file:
        taxa = defaultdict(list)
        for line in pop_file:
            pop, sample = [x.rstrip('\s\n') for x in line.split()]
            if sample in snps_table.index:
                taxa[pop].append(sample)

elif args.table:
    info = pandas.read_csv(args.table)
    taxa = defaultdict(list)
    for i, row in info.iterrows():
        if row.loc[args.sample_field] in snps_table.index:
            taxa[row.loc[args.population_field]].append(row.loc[args.sample_field])
            
else:
    taxa = {'ALLSAMPLES':sorted(snps_table.index)}


## filter out loci not found in every population
if args.filter:
    for locus_name,locus in snps_table.iteritems():
        all_pops = True
        for pop in taxa.iterkeys():
            temp = locus.loc[locus.index.isin(taxa[pop]) &
                             -locus.isin(['N','-'])]
            if not len(temp): #if any pop has N's or -'s for all samples, mark as false an break
                all_pops = False
                break
        if not all_pops:
            snps_table.drop(locus_name, axis = 1, inplace = True)


## write output
with open(outpath, 'w') as outfile:
    outfile.write('genepop file generated from ' + os.path.basename(unlinked_snps) + '.\n')
    for locus in snps_table.columns:
        outfile.write('SNP_' + str(locus) + '\n')
    for pop in taxa.iterkeys():
        outfile.write('POP\n')
        for sample in taxa[pop]:
            if sample in snps_table.index:
                temp = [to_genpop(i) for i in snps_table.loc[sample]]
                if args.append_pop_names:
                    outfile.write(sample + '_' + pop + ', ')
                else:
                    outfile.write(sample + ', ')
                outfile.write(' '.join(temp) + '\n')
