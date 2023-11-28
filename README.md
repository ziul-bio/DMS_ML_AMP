[![author](https://img.shields.io/badge/author-Luiz_Vieira-blue.svg)](https://www.linkedin.com/in/luiz-carlos-vieira-4582797b/) [![The Wilke Lab](https://img.shields.io/badge/Wilke-Lab-brightgreen.svg?style=flat)](https://wilkelab.org/) [![The Davis Lab](https://img.shields.io/badge/Davis-Lab-blue.svg?style=flat)](https://bwdaviesutaustin.org/) [![](https://img.shields.io/badge/python-3.8+-yellow.svg)](https://www.python.org/downloads/release/python) [![](https://img.shields.io/badge/R%20Version-4.2.0-yellow.svg)](https://cran.r-project.org/bin/windows/base/) [![contributions welcome](https://img.shields.io/badge/contributions-welcome-red.svg?style=flat)](https://github.com/ziul-bio/DMS_ML_AMP/issues) 

<img width="120px" alt="Slay logo" align="right" src="figures/logo.png">


# Deep mutational scanning and machine learning uncover antimicrobial peptide features driving membrane selectivity 


This workflow is based on the paper "Tucker et al., Cell. 2018. Discovery of Next-Generation   
Antimicrobials through Bacterial Self-Screening of Surface-Displayed Peptide Libraries". [Link](https://www.cell.com/cell/fulltext/S0092-8674(17)31451-4?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS0092867417314514%3Fshowall%3Dtrue)

Some changes were applied in the pipeline to fit the new data.  

Here we describe all the steps required to reproduce the analysis on the paper "Deep mutational scanning and machine learning uncover antimicrobial peptide features driving membrane selectivity", Author Justin R. Randall.  


# Workflow

This work flow is divided in 2 parts. Deep mutational scanning and Machine Learning.

## Part 1 - Deep Mutational Scanning

### Get Counts

One can run the script [getCounts.sh](https://github.com/ziul-bio/DMS_ML_AMP/blob/main/scripts/01_getCount.sh) to obtain the result we did.  
To run this script you will need [seqkit](https://bioinf.shenwei.me/seqkit/) and [flexbar](https://github.com/seqan/flexbar) installed in a unix enviromet.  

**Note: Since tha raw FASTQ files are larger the limit size allowed in github, they are not available yet, this script will not work.**


### Compute Changes in the Peptides Sequence

We translated the peptide sequences with the [biopython translate function](https://biopython.org/docs/1.75/api/Bio.Seq.html), and compute the differences on the sequence with the reference protegrin-1 protein using a custom python script, described on [translate_and_compute_changes_in_peptides.ipynb](https://github.com/ziul-bio/DMS_ML_AMP/blob/main/02_translate_peptides_and_stack.ipynb).

### Differential Expression Analysis

The differential analysis was done in R with [Deseq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html), described in the notebook [deseq2_analysis.rmd](https://github.com/ziul-bio/DMS_ML_AMP/blob/main/03_Analyse_Deseq2.Rmd).  


## Part 2 - Machine Learning

### The notebooks 04 throught 06 shown the procedure used to train and test the model.

#### [Hemolysis Model](https://github.com/ziul-bio/DMS_ML_AMP/blob/main/04_hemolysis_model_v01.ipynb)
#### [Selectivity Model](https://github.com/ziul-bio/DMS_ML_AMP/blob/main/05_Selectivity_model_v01.ipynb)
#### [Activity Model](https://github.com/ziul-bio/DMS_ML_AMP/blob/main/06_Activity_model_v01.ipynb)

#### All these 3 models work in concensus to make the final predictions described in notebook [AMP Predictions](https://github.com/ziul-bio/DMS_ML_AMP/blob/main/07_AMP_predictions_v01.ipynb)


# To create a conda enviroment with all the requeriment package run:
    conda env create -f environment.yml -n DMS_ML_AMP


All the code are commented so feel free to change the parameters to suit your data and needs.
