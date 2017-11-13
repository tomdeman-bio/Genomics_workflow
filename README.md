# Genomics_workflow
# An easy bacterial assembly and annotation pipeline 

## Remove PhiX from raw reads using [bbduk](https://sourceforge.net/projects/bbmap/)

### Usage
    perl run_bbduk.pl directory/containing/raw/reads/only/*
--------------------------------------

## Trimming PhiX free reads using [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)

### Usage
    perl run_trimmomatic.pl directory/containing/PhiX/free/reads/only/*
--------------------------------------

## Assembling contigs from PhiX free and trimmed reads using [SPAdes](http://spades.bioinf.spbau.ru)

### Usage
    perl run_SPAdes.pl directory/containing/trimmed/and/virus/free/reads/only/*
--------------------------------------

## Assembling plasmid contigs, rather than plasmid + chromosomal sequences, from PhiX free and trimmed reads using [PlasmidSPAdes](http://spades.bioinf.spbau.ru)  

### Usage
    perl run_plasmidSPAdes.pl directory/containing/PhiX_and_contaminant/free/reads/only/*
--------------------------------------

## Perform all four steps indicated above (bbduk-Trimmomatic-SPAdes-PlasmidSPAdes) plus BUSCO genome assembly QC, MLST genotyping, plasmid replicon gene identification, AMR gene detection, and Prokka protein coding gene annotation using one Bash script. Script will only annotate/genotype contigs of 500bp and larger (contigs are filtered using contig_size_select.pl)

### Usage
    bash bbduk-trimmomatic-SPAdes-plasmidSPAdes-prokka-BUSCO.bash
--------------------------------------
