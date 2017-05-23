#!/bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=8,vmem=100gb,walltime=10:00:00
#PBS -M mmuscare@indiana.edu,wrshoema@indiana.edu,lennonj@indiana.edu
#PBS -m abe
#PBS -j oe
module load java
module load fastqc
module load bioperl
module load python
module load cutadapt
module load khmer
module load velvet
module load VelvetOptimiser
PATH=$PATH:/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13
GENOME=${var1}
cd /N/dc2/projects/Lennon_Sequences/2014_SoilGenomes/$GENOME
R1=$GENOME*R1*.fastq
R2=$GENOME*R2*.fastq
fastqc $R1 >> results.out
fastqc $R2 >> results.out
cutadapt -q 10 -a AGATCGGAAGAGC --minimum-length 20 -o ./tmp.1.fastq -p ./tmp.2.fastq ./$R1 ./$R2
cutadapt -q 10 -a AGATCGGAAGAGC --minimum-length 20 -o ./$GENOME.R2.trim.fastq -p ./$GENOME.R1.trim.fastq ./tmp.2.fastq ./tmp.1.fastq
rm ./tmp.1.fastq ./tmp.2.fastq
interleave-reads.py ./$GENOME.R1.trim.fastq ./$GENOME.R2.trim.fastq -o ./$GENOME.trim.interleaved.fastq      
fastq_quality_filter -Q33 -q 30 -p 50 -i ./$GENOME.trim.interleaved.fastq > ./$GENOME.trim.interleaved.trim.fastq
extract-paired-reads.py ./$GENOME.trim.interleaved.trim.fastq
normalize-by-median.py -k 25 -C 25 -N 4 -x 2e9 -p ./$GENOME.trim.interleaved.trim.fastq.pe
extract-paired-reads.py ./$GENOME.trim.interleaved.trim.fastq.pe.keep
VelvetOptimiser.pl -s 31 -e 71 -f '-shortPaired -fastq ./'$GENOME'.trim.interleaved.trim.fastq.pe.keep.pe' -t 8 -k 'n50*ncon' --p $GENOME'assembled'
