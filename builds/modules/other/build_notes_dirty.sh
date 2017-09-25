I am submitting a request to install the following programs onto the saguaro HPC.

# (1) QIIME2 (https://qiime2.org/)

mkdir /packages/6x/build/qiime2/2017.7.0
cd /packages/6x/build/qiime2/2017.7.0
# add the download file
cat <<EOF >> download.sh
#!/bin/bash

module purge

module load git/2.12.2

# the python module files
#git clone --branch 2017.7.0 https://github.com/qiime2/qiime2.git
# the python cli tool for qiime2...
git clone --branch 2017.7.0 https://github.com/qiime2/q2cli.git

module purge

EOF

# add the build file

module load anaconda/4.4.0

# conda update anaconda

conda create -n qiime2-2017.7 --file https://data.qiime2.org/distro/core/qiime2-2017.7-conda-linux-64.txt

source activate qiime2-2017.7



# and test it:
cat <<EOF >> test_qiime2.sh
#!/bin/bash
#module load qiime2/2017.7
module load anaconda
source activate qiime2-2017.7

cd ~
mkdir qiime2-moving-pictures-tutorial
cd qiime2-moving-pictures-tutorial
# metadata file
wget -O "sample-metadata.tsv" "https://data.qiime2.org/2017.7/tutorials/moving-pictures/sample_metadata.tsv"
#
mkdir emp-single-end-sequences
wget -O "emp-single-end-sequences/barcodes.fastq.gz" "https://data.qiime2.org/2017.7/tutorials/moving-pictures/emp-single-end-sequences/barcodes.fastq.gz"

qiime tools import \
  --type EMPSingleEndSequences \
  --input-path emp-single-end-sequences \
  --output-path emp-single-end-sequences.qza


qiime demux emp-single \
  --i-seqs emp-single-end-sequences.qza \
  --m-barcodes-file sample-metadata.tsv \
  --m-barcodes-category BarcodeSequence \
  --o-per-sample-sequences demux.qza

# I'm not connected from a mac, if i was using NoMachine this probably would have worked:
qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv
# Plugin error from demux:
#   Invalid DISPLAY variable
# Debug info has been saved to /tmp/qiime2-q2cli-err-syu910j4.log.

qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left 0 \
  --p-trunc-len 120 \
  --o-representative-sequences rep-seqs-dada2.qza \
  --o-table table-dada2.qza

mv rep-seqs-dada2.qza rep-seqs.qza
mv table-dada2.qza table.qza

qiime quality-filter q-score \
 --i-demux demux.qza \
 --o-filtered-sequences demux-filtered.qza \
 --o-filter-stats demux-filter-stats.qza

qiime deblur denoise-16S \
  --i-demultiplexed-seqs demux-filtered.qza \
  --p-trim-length 120 \
  --o-representative-sequences rep-seqs-deblur.qza \
  --o-table table-deblur.qza \
  --o-stats deblur-stats.qza

mv rep-seqs-deblur.qza rep-seqs.qza
mv table-deblur.qza table.qza

# again failed, no driver for graphics
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv
# Plugin error from feature-table:
#   Invalid DISPLAY variable
# Debug info has been saved to /tmp/qiime2-q2cli-err-pxedehls.log.  
qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv

qiime alignment mafft \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza

qiime alignment mask \
  --i-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza

qiime phylogeny fasttree \
  --i-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza

qiime phylogeny midpoint-root \
  --i-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza

qiime diversity core-metrics \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 1109 \
  --output-dir core-metrics-results

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-category BodySite \
  --o-visualization core-metrics-results/unweighted-unifrac-body-site-significance.qzv \
  --p-pairwise
# Plugin error from diversity:
#   Invalid DISPLAY variable
# Debug info has been saved to /tmp/qiime2-q2cli-err-79xkwcru.log.

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-category Subject \
  --o-visualization core-metrics-results/unweighted-unifrac-subject-group-significance.qzv \
  --p-pairwise
# Plugin error from diversity:
#   Invalid DISPLAY variable
# Debug info has been saved to /tmp/qiime2-q2cli-err-f6pxzfo4.log.

qiime emperor plot \
  --i-pcoa core-metrics-results/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-custom-axis DaysSinceExperimentStart \
  --o-visualization core-metrics-results/unweighted-unifrac-emperor.qzv

qiime emperor plot \
  --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-custom-axis DaysSinceExperimentStart \
  --o-visualization core-metrics-results/bray-curtis-emperor.qzv

wget -O "gg-13-8-99-515-806-nb-classifier.qza" "https://data.qiime2.org/2017.7/common/gg-13-8-99-515-806-nb-classifier.qza"

qiime feature-classifier classify-sklearn \
  --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza

qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv

qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv

source deactivate
EOF


cat <<EOF >> build.sh
#!/bin/bash

source /packages/6x/build/header.source

module purge

osprefix="6x"
module=""
version=""
build_dir="/packages/$osprefix/build/$module/$version"
source_file="$build_dir/xxx-tar"
source_dir="$build_dir/xxx"

if [ -d $source_dir ]; then
  rm -rf $source_dir
fi

tar -xzf $source_file



if [ ! -d $source_dir ]; then
	/bin/bash $build_dir/download.sh
fi

module load make/4.1
module load python/3.6.1

cd $source_dir

echo-yellow "\nInstalling\n"

make 2>&1 | tee $build_dir/_build.out
pipe_error_check

module purge

# NOTE: usage will be q2cli
EOF

Cython
matplolib (1.3.0, newer versions may not work)
NumPy
psutil (0.6.1, newer versions may not work)
PySam
setuptools
PerlIO::gzip



(2) Bioperl (http://bioperl.org/)
(3) MEME suite (the database and suitesoftware: http://meme-suite.org/doc/download.html?man_type=web)



(4) R packages 'biclust' and 'WGCNA'
module load r/3.3.2
R
install.packages('WGCNA')
install.packages('biclust')



(5) PAML (http://abacus.gene.ucl.ac.uk/software/paml.html#download)
(6) Bridger (https://sourceforge.net/projects/rnaseqassembly/files/?source=navbar)
(7) MOCAT2  (http://vm-lux.embl.de/~kultima/MOCAT/)
(8) metAMOS (https://github.com/marbl/metAMOS)
(9) Glimmer_MG (http://www.cbcb.umd.edu/software/glimmer-mg/)


most of these programs are for microbiome analysis (reads assymbly and gene prediction) and gene regulatory analysis. our team is ready to work so we will appreciate you could have these installed and tested at your earliest conveniences.
