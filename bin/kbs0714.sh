#!/bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=8,vmem=100gb,walltime=12:00:00
#PBS -M wrshoema@indiana.edu,mmuscare@indiana.edu
#PBS -m abe
#PBS -j oe

module load java
module load fastqc
module load bioperl
module load python
module load gcc
module load cutadapt
module load khmer
module load velvet
module load VelvetOptimiser
PATH=$PATH:/N/soft/mason/galaxy-apps/fastx_toolkit_0.0.13

IN=/N/dc2/projects/Lennon_Sequences/2017_Micrococcus/KBS0714
OUT=/N/dc2/projects/Lennon_Sequences/2017_Micrococcus/KBS0714_test

#fastqc "${IN}/KBS0714_R1.fastq" --outdir=$OUT >> "${OUT}/results.out"
#fastqc "${IN}/KBS0714_R2.fastq" --outdir=$OUT >> "${OUT}/results.out"

#cutadapt -q 10,10 -b AGATCGGAAGAGC -B AGATCGGAAGAGC --minimum-length 30 \
#  -o "${OUT}/KBS0714.R1.trim.fastq" -p "${OUT}/KBS0714.R2.trim.fastq" "${IN}/KBS0714_R1.fastq" "${IN}/KBS0714_R2.fastq"
cd /N/dc2/projects/Lennon_Sequences/2017_Micrococcus/KBS0714_test

#interleave-reads.py ./KBS0714.R1.trim.fastq ./KBS0714.R2.trim.fastq \
#  -o ./KBS0714.trim.interleaved.fastq
#fastq_quality_filter -Q33 -q 30 -p 50 -i ./KBS0714.trim.interleaved.fastq \
#  > ./KBS0714.trim.interleaved.trim.fastq
#extract-paired-reads.py ./KBS0714.trim.interleaved.trim.fastq
#normalize-by-median.py -k 25 -C 25 -N 4 -x 2e9 -p ./KBS0714.trim.interleaved.trim.fastq.pe
#extract-paired-reads.py ./KBS0714.trim.interleaved.trim.fastq.pe.keep
VelvetOptimiser.pl -s 31 -e 71 -f '-shortPaired -fastq ./KBS0714.trim.interleaved.trim.fastq.pe.keep.pe' -t 8 -k 'n50*ncon' --p 'KBS0714assembled'
