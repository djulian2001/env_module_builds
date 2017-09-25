#!/bin/bash
# build steps for r with anaconda3

# (4) R packages 'biclust' and 'WGCNA'   !COMPLETED!
module load r/3.3.2
# and
module load anaconda3/4.4.0
source activate qiime2-2017.7

# commands:
R
install.packages('WGCNA')
install.packages('biclust')
module purge
