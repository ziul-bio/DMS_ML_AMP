#!/usr/bin/env bash

# uninduced reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/040/SRR26222940/SRR26222940_1.fastq.gz -o rawFastq/S1_0uM_IPTG_1/PG_0_1F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/040/SRR26222940/SRR26222940_2.fastq.gz -o rawFastq/S1_0uM_IPTG_1/PG_0_1R.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/038/SRR26222938/SRR26222938_1.fastq.gz -o rawFastq/S2_0uM_IPTG_2/PG_0_2F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/038/SRR26222938/SRR26222938_2.fastq.gz -o rawFastq/S2_0uM_IPTG_2/PG_0_2R.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/037/SRR26222937/SRR26222937_1.fastq.gz -o rawFastq/S3_0uM_IPTG_3/PG_0_3F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/037/SRR26222937/SRR26222937_2.fastq.gz -o rawFastq/S3_0uM_IPTG_3/PG_0_3R.fastq.gz
# induced reads
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/036/SRR26222936/SRR26222936_1.fastq.gz -o rawFastq/S10_100uM_IPTG_1/PG_100_1F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/036/SRR26222936/SRR26222936_2.fastq.gz -o rawFastq/S10_100uM_IPTG_1/PG_100_1R.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/035/SRR26222935/SRR26222935_1.fastq.gz -o rawFastq/S11_100uM_IPTG_2/PG_100_2F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/035/SRR26222935/SRR26222935_2.fastq.gz -o rawFastq/S11_100uM_IPTG_2/PG_100_2R.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/039/SRR26222939/SRR26222939_1.fastq.gz -o rawFastq/S12_100uM_IPTG_3/PG_100_3F.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR262/039/SRR26222939/SRR26222939_2.fastq.gz -o rawFastq/S12_100uM_IPTG_3/PG_100_3R.fastq.gz
