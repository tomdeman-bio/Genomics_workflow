#!/bin/sh

mkdir PhiX_free_reads
mkdir trimmed_PhiX_free_reads
mkdir assemblies
mkdir assemblies_500
mkdir Plasmid_assemblies
mkdir Prokka_stats
mkdir BUSCO_stats

perl run_bbduk.pl raw_reads/*

mv raw_reads/*_noPhiX PhiX_free_reads

perl run_trimmomatic.pl PhiX_free_reads/*

mv PhiX_free_reads/*paired_trimmed* trimmed_PhiX_free_reads

perl run_SPAdes.pl trimmed_PhiX_free_reads/*
perl run_plasmidSPAdes.pl trimmed_PhiX_free_reads/*

#move assemblies to different folder
for file in *_assembly/scaffolds.fasta; do new="$(echo "$file" | cut -d '_' -f 1)".scaffolds.fasta; cp "$file" "assemblies/$new"; done
for file in *_PLASMID_contigs/scaffolds.fasta; do new="$(echo "$file" | cut -d '_' -f 1)".scaffolds.fasta; cp "$file" "Plasmid_assemblies/$new"; done

#filter contigs on length
for i in assemblies/*.fasta; do perl contig_size_select.pl -low 500 $i > $i.500.fna; done
mv assemblies/*.fna assemblies_500

#Check if genomes are complete gene content wise. Make sure to add the right lineage db to -l
for i in assemblies_500/*.fna

do
	location="$(echo "$i" | cut -d '.' -f 1)"
	name="$(echo "$location" | cut -d '/' -f 2)"
	BUSCO.py -i $i -o BUSCO_$name -l /path/to/BUSCO/lineage_data/species_odb9 -m geno -c 12
done

#take all BUSCO summaries and plot data
for file in run_BUSCO_*/*.txt; do cp $file BUSCO_stats; done
BUSCO_plot.py -wd BUSCO_stats

#annotate HQ contigs
for i in assemblies_500/*.fna

do
	location="$(echo "$i" | cut -d '.' -f 1)"
	name="$(echo "$location" | cut -d '/' -f 2)"
	prokka --kingdom Bacteria --outdir prokkaDIR_$name --locustag $name $i
done

for file in prokkaDIR_*/*.txt; do cp $file Prokka_stats; done
