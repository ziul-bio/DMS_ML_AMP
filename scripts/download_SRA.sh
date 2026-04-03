#!/usr/bin/env bash
# Create output directory if it doesn't exist
mkdir -p data/rawFastq
# Download the fastq files from SRA using curl
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/040/SRR26222940/SRR26222940_1.fastq.gz -o data/rawFastq/S1_SRR26222940_Uninduced_1F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/038/SRR26222938/SRR26222938_1.fastq.gz -o data/rawFastq/S2_SRR26222938_Uninduced_2F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/037/SRR26222937/SRR26222937_1.fastq.gz -o data/rawFastq/S3_SRR26222937_Uninduced_3F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/036/SRR26222936/SRR26222936_1.fastq.gz -o data/rawFastq/S10_SRR26222936_Induced_1F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/035/SRR26222935/SRR26222935_1.fastq.gz -o data/rawFastq/S11_SRR26222935_Induced_2F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/039/SRR26222939/SRR26222939_1.fastq.gz -o data/rawFastq/S12_SRR26222939_Induced_3F.fastq.gz