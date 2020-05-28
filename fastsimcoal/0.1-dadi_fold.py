#!/usr/bin/env python 

# In this script, we will use dadi to fold a site frequency spectrum
# The path to the SFS to be folded has to be given as command-line argument

import os, sys, dadi

infile = sys.argv[1]
outfile = sys.argv[2]

SFS = dadi.Spectrum.from_file(infile, mask_corners=False)
SFS
SFS_folded = SFS.fold()

SFS_folded.to_file(outfile)


