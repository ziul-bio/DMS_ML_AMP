# W3110_PG-1 Project - Part 1


This workflow is based on the paper "Tucker et al., Cell. 2018. Discovery of Next-Generation   
Antimicrobials through Bacterial Self-Screening of Surface-Displayed Peptide Libraries". [Link](https://www.cell.com/cell/fulltext/S0092-8674(17)31451-4?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS0092867417314514%3Fshowall%3Dtrue)

Some changes were applied in the pipeline to fit the new data.  

Here we describe getCounts.sh scripts, step by step to count the reads.  


## Amplicon Structure

    5' Amplicon head:
    aatgatacggcgaccaccgagatctacactctttccctacacgacgctcttccgatctctccaGCTGCGGGTATCGGAGGAACC
                                                                

    Variable region = Protegrin-1 library:
    nnnNNNnnnNNNnnnNNNnnnNNNnnnNNNnnnNNNnnnNNNnnnNNNnnnNNN

    5' Amplicon tail:
    taagtcgacctgcaggcatgcaagcttggcagatcggaagagcacacgtctgaactccagtcacNNNNNNatctcgtatgccgtcttctgcttg  

    Protegrin-1 library: 
    cgc ggt ggg cgt ctt tg(c/t) ta(c/t) tg(c/t) cgt cgc agg ttc tg(c/t) gtt tg(c/t) gta gga cgt taa

    Read exemple:
    CGCGGTGGGCGTCTTTGxTAxTGxCGTCGCAGGTTCTGxGTTTGxGTAGGACGTTAA


    Protegrin-1 peptide sequence:
    RGGRLCYCRRRFCVCVGR



## Filtering and Trimming reads


### Filter for quality avarege >= 30

[Why 30?](https://www.illumina.com/science/technology/next-generation-sequencing/plan-experiments/quality-scores.html)
Q30 is considered a benchmark for quality in next-generation sequencing (NGS).  
When sequencing quality reaches Q30, virtually all of the reads will be perfect, with no errors or 
ambiguities. This will avoid mistaken count reads for the peptides.  

```bash
#command
seqkit seq -Q 30 sample_1_F.fastq.gz > sample_1_F_Q30.fastq
```


### Filtering reads that have the firsts codons of the amplicon

    query:
    "amplicon_head21nt"       "Anything in here will be the variable regions"
    "GCTGCGGGTATCGGAGGAACC"   "CGCGGTGGGCGTCTTTGxTAxTGxCGTCGCAGGTTCTGxGTTTGxGTAGGACGTTAA"

```bash
#command to filter
seqkit grep -s -p "GCTGCGGGTATCGGAGGAACC" sample_1_F_Q30.fastq > sample_1_F_Q30_filtered.fasta
```

#### Output
    Read in fastq files:
    CTCCAGCTGCGGGTATCGGAGGAACCCGCGGTGGGCGTCTTTGTTACTGCCGTCGGAGGTTCTGTGTTTGTGTAGGACGTTAAGTCGACCTGCAGGCATG                          
                              ||||||||||||||||| || || ||||| |||||||| ||||| ||||||||||||     
                              CGCGGTGGGCGTCTTTGxTAxTGxCGTCGCAGGTTCTGxGTTTGxGTAGGACGTTAA
    Protegrin-1 match


### Trimming with flexbar

To trimm the reads, use the same sequence that was used to filter the sequences.

    adapter_left.fasta
    >adapter_L1
    GCTGCGGGTATCGGAGGAACC


```bash
#command
flexbar --reads sample_1_F_Q30_filtered.fasta --adapters adapter_Left.fasta --adapter-trim-end ANY --target sample_1_F_Q30_filtered_trimmed
```


### Counting uniq reads

#-c – -count : It tells how many times a line was repeated by displaying a number as a prefix with the line.  
#-d – -repeated : It only prints the repeated lines and not the lines which aren’t repeated.  
 
```bash
#command
time awk '(NR%4==2)' sample_1_F_Q30_filtered_trimmed.fastq | sort | uniq -cd > Counts/S1_uniq.txt
```


### Filtering Counts

To guarantee a good differential expression analysis, we filter just the reads from the control groups that appear at least 9 times.
```bash
#command
awk '{if($1 >=9) print $0}' Counts/S1_uniq_counts.txt > Counts/S1_uniq_counts_filtered.txt
awk '{if($1 >=9) print $0}' Counts/S2_uniq_counts.txt > Counts/S2_uniq_counts_filtered.txt
awk '{if($1 >=9) print $0}' Counts/S3_uniq_counts.txt > Counts/S3_uniq_counts_filtered.txt
```


### joining counts

Now is just merge the count matrixes with a left join function.  
The files need to be sorted and the merge should start from the control groups. Then if the file 2 doesn't have a match,  
NA will be applied to the count reads.

```bash
#command
join -1 2 -2 2 <(sort -k 2 Counts/S1_uniq_counts_filtered.txt) <(sort -k 2 Counts/S2_uniq_counts_filtered.txt) -a1 > Counts/matrix_1-2.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_1-2.txt) <(sort -k 2 Counts/S3_uniq_counts_filtered.txt) -a1 > Counts/matrix_3.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_3.txt) <(sort -k 2 Counts/S4_uniq_counts.txt) -a1 > Counts/matrix_4.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_4.txt) <(sort -k 2 Counts/S5_uniq_counts.txt) -a1 > Counts/matrix_5.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_5.txt) <(sort -k 2 Counts/S6_uniq_counts.txt) -a1 > Counts/matrix_6.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_6.txt) <(sort -k 2 Counts/S7_uniq_counts.txt) -a1 > Counts/matrix_7.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_7.txt) <(sort -k 2 Counts/S8_uniq_counts.txt) -a1 > Counts/matrix_8.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_8.txt) <(sort -k 2 Counts/S9_uniq_counts.txt) -a1 > Counts/matrix_9.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_9.txt) <(sort -k 2 Counts/S10_uniq_counts.txt) -a1 > Counts/matrix_10.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_10.txt) <(sort -k 2 Counts/S11_uniq_counts.txt) -a1 > Counts/matrix_11.txt
join -1 1 -2 2 <(sort -k 1 Counts/matrix_11.txt) <(sort -k 2 Counts/S12_uniq_counts.txt) -a1 > Counts/counts_matrix.txt
```

The join function might duplicate some rows, so just filter those before the differential expression analysis with deseq2.


