#!/usr/bin/bash

#Exit program if any erro accurs
set -o errexit

echo "************************************************************************************************"
echo "                          Deep mutational scanning - Part 1 - Count reads"
echo "************************************************************************************************"
echo " "
echo " "

echo "*************************************** Starting Process ***************************************"
echo " "
FASTQ=./data/rawFastq
INPUT=./data
OUTDIR=./data/counts


for i in {1..12};
#for i in 1 2 3 10 11 12;
do
    echo "Processing sample $i"
    echo "Filtering fastq file for reads that match the firsts codon of the aplicom sequence"
    time seqkit grep -s -p "GCTGCGGGTATCGGAGGAACC" ${FASTQ}/S"$i"_*_IPTG_[1-3]/PG*F.fastq.gz > ${OUTDIR}/reads_IPTG_filtered.fastq
    echo " "

    echo "Filtering fastq file with average quality higher or equal to 30%"
    time seqkit seq -Q 30 ${OUTDIR}/reads_IPTG_filtered.fastq > ${OUTDIR}/reads_IPTG_filtered_Q30.fastq
    echo " "

    echo "Trimming the reads with fleaxbar"
    # the adapter is "GCTGCGGGTATCGGAGGAACC" and what is left are the 74 nuc from the amplicon
    time flexbar --reads ${OUTDIR}/reads_IPTG_filtered_Q30.fastq --adapters ${INPUT}/adapters_Left.fasta --adapter-trim-end ANY --target ${OUTDIR}/reads_trimmed
    echo " "

    echo "Filtering uniq reads"
    #-c – -count : It tells how many times a line was repeated by displaying a number as a prefix with the line.
    #-d – -repeated : It only prints the repeated lines and not the lines which aren’t repeated.
    time awk '(NR%4==2)' ${OUTDIR}/reads_trimmed.fastq | sort | uniq -cd > ${OUTDIR}/S"$i"_uniq_counts.txt
    echo " "

    rm ${OUTDIR}/*.fastq
    rm ${OUTDIR}/*.log

done

# Filtering ${OUTDIR}
echo "Filtering counts"
awk '{if($1 >=9) print $0}' ${OUTDIR}/S1_uniq_counts.txt > ${OUTDIR}/S1_uniq_counts_filtered.txt
awk '{if($1 >=9) print $0}' ${OUTDIR}/S2_uniq_counts.txt > ${OUTDIR}/S2_uniq_counts_filtered.txt
awk '{if($1 >=9) print $0}' ${OUTDIR}/S3_uniq_counts.txt > ${OUTDIR}/S3_uniq_counts_filtered.txt

# Joining ${OUTDIR}
# -a1 will keep all rows in the control data and add NAs to trt data if it doesn't have values.
echo "joining counts"
join -1 2 -2 2 <(sort -k 2 ${OUTDIR}/S1_uniq_counts_filtered.txt) <(sort -k 2 ${OUTDIR}/S2_uniq_counts_filtered.txt) -a1 > ${OUTDIR}/matrix_1-2.txt
join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_1-2.txt) <(sort -k 2 ${OUTDIR}/S3_uniq_counts_filtered.txt) -a1 > ${OUTDIR}/matrix_3.txt

join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_3.txt) <(sort -k 2 ${OUTDIR}/S4_uniq_counts.txt) -a1 > ${OUTDIR}/matrix_4.txt
join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_4.txt) <(sort -k 2 ${OUTDIR}/S5_uniq_counts.txt) -a1 > ${OUTDIR}/matrix_5.txt
join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_5.txt) <(sort -k 2 ${OUTDIR}/S6_uniq_counts.txt) -a1 > ${OUTDIR}/matrix_6.txt
join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_6.txt) <(sort -k 2 ${OUTDIR}/S7_uniq_counts.txt) -a1 > ${OUTDIR}/matrix_7.txt
join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_7.txt) <(sort -k 2 ${OUTDIR}/S8_uniq_counts.txt) -a1 > ${OUTDIR}/matrix_8.txt
join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_8.txt) <(sort -k 2 ${OUTDIR}/S9_uniq_counts.txt) -a1 > ${OUTDIR}/matrix_9.txt
join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_9.txt) <(sort -k 2 ${OUTDIR}/S10_uniq_counts.txt) -a1 > ${OUTDIR}/matrix_10.txt
join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_10.txt) <(sort -k 2 ${OUTDIR}/S11_uniq_counts.txt) -a1 > ${OUTDIR}/matrix_11.txt
join -1 1 -2 2 <(sort -k 1 ${OUTDIR}/matrix_11.txt) <(sort -k 2 ${OUTDIR}/S12_uniq_counts.txt) -a1 > ${OUTDIR}/count_matrix.txt

rm ${OUTDIR}/matrix_*.txt

echo "*************************************** Process finished ********************************************"