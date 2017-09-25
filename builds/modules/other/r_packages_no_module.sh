
wget http://bioconductor.org/packages/release/bioc/src/contrib/VariantAnnotation_1.20.3.tar.gz .
wget http://bioconductor.org/packages/release/bioc/src/contrib/Rsamtools_1.26.1.tar.gz .
wget http://bioconductor.org/packages/release/bioc/src/contrib/S4Vectors_0.12.2.tar.gz .
wget https://bioconductor.org/packages/3.2/bioc/src/contrib/S4Vectors_0.8.11.tar.gz .

wget http://bioconductor.org/packages/release/bioc/src/contrib/GenomeInfoDb_1.10.3.tar.gz .

https://www.rdocumentation.org/packages/S4Vectors

install.packages("/packages/6x/build/R/3.2.5/downloads/", repos = NULL, type="source")


# done install.packages("/packages/6x/build/R/3.2.5/downloads/DNAcopy_1.48.0.tar.gz", repos = NULL, type="source")
# done install.packages("/packages/6x/build/R/3.2.5/downloads/Rsamtools_1.26.1.tar.gz", repos = NULL, type="source")
# too new for 3.2.5 install.packages("/packages/6x/build/R/3.2.5/downloads/S4Vectors_0.12.2.tar.gz", repos = NULL, type="source")
install.packages("/packages/6x/build/R/3.2.5/downloads/S4Vectors_0.8.11.tar.gz", repos = NULL, type="source")



install.packages("/packages/6x/build/R/3.2.5/downloads/GenomeInfoDb_1.10.3.tar.gz", repos = NULL, type="source")

install.packages("/packages/6x/build/R/3.2.5/downloads/VariantAnnotation_1.20.3.tar.gz", repos = NULL, type="source")
install.packages("/packages/6x/build/R/3.2.5/downloads/PureCN_1.2.3.tar.gz", repos = NULL, type="source")



# switching to 3.3.2

install.packages("BiocInstaller", repos="http://bioconductor.org/packages/3.4/bioc")

# switching to 3.3.1

	# biocLite("Rsamtools")
	# biocLite("BiocGenerics")
	# biocLite("GenomeInfoDb")
	# biocLite("GenomicRanges")


	biocLite("SummarizedExperiment")
		biocLite(c("GenomicRanges","Biobase"))

		wget http://bioconductor.org/packages/release/bioc/src/contrib/Biobase_2.30.0.tar.gz .
		packages.install("/packages/6x/build/R/3.3.1/downloads/Biobase_2.30.0.tar.gz", repos = NULL, type="source")


# had to reach out to Lee.  This is old-n-busted... aka centos 6.6 glib 



install.packages(c("MASS",)
install.packages(c("MASS","psych","GPArotation","lavaan","MCMCpack"))



git remote add origin git@github.com:primusdj/vagrant-devstack.git
