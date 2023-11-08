# ---
# title: "Deep mutational scanning and machine learning uncover antimicrobial peptide features driving membrane selectivity"
# subtitle: Part 3, Differential Expression Analysis with DESeq2"
# author: "Luiz Carlos Vieira"
# date: "09/25/2023"
# ---


# Differential expression analysis with DESeq2 involves multiple steps. First, DESeq2 will model the raw 
# Counts, using normalization factors (size factors) to account for differences in library depth. 

# Second, it will estimate the gene-wise dispersion and shrink these estimates to generate more accurate
# estimates of dispersion to model the Counts. 

# Third, DESeq2 will fit the negative binomial model and perform hypothesis testing using the Wald test or 
# Likelihood Ratio Test.

# [Love, M.I., 2014](https://doi.org/10.1186/s13059-014-0550-8)


## Libraies
suppressPackageStartupMessages(library(DESeq2, quietly = TRUE))
library(ggplot2, quietly = TRUE)
library(ggrepel, quietly = TRUE)
suppressPackageStartupMessages(library(dplyr, quietly = TRUE))
library(pheatmap, quietly = TRUE)
library(RColorBrewer, quietly = TRUE)
library(openxlsx, quietly = TRUE)
setwd(getwd())

# Loading count matrix
print('#------------- Loading matrix counts data ----------------#')
count_matrix <- read.csv(paste(getwd(), "/data/counts/counts_matrix_stacked.csv", sep=""), header=TRUE, sep = ",")

# Define Columns to be selected
cols <- c("S01_0uM_IPTG_1", "S02_0uM_IPTG_2", "S03_0uM_IPTG_3",
          "S04_1uM_IPTG_1", "S05_1uM_IPTG_2", "S06_1uM_IPTG_3",
          "S07_10uM_IPTG_1", "S08_10uM_IPTG_2", "S09_10uM_IPTG_3",
          "S10_100uM_IPTG_1", "S11_100uM_IPTG_2", "S12_100uM_IPTG_3")


# filling NAs with zeros.
count_matrix[is.na(count_matrix)] <- 0

# making ID the rownames of creating matrix matrix
row.names(count_matrix) <- count_matrix$ID
Counts <- count_matrix[cols]
Counts <- as.matrix(Counts)


## Creating a coldata table info as sample_id and conditions.
coldata <- data.frame(row.names = colnames(Counts),
                       group= rep(c("Zero", "One", "Ten", "Hnd"), each=3))


# convert column "condition" to "factor"
coldata$group <- factor(coldata$group, levels = c("Zero", "One", "Ten", "Hnd"))


# DESeq2 object
print('#-------- Running Deseq2 ---------#')
dds <- DESeqDataSetFromMatrix(countData=Counts, colData=coldata, design= ~group)

## Filters out row sums smaller than 30 Counts.
filtro <- rowSums(counts(dds)) >= 30
 
dds <- dds[filtro, ]


### relevel() to define reference level. 
dds$group <- relevel(dds$group, ref = "Zero")


## running deseq2
ddsDE <- DESeq(dds)

### Checking group comparions:
resultsNames(ddsDE)



### Getting the results 
print('#-------------- Creating results dataframe ---------#')
####Setting a alpha value of 0.05 for each comparison
resOne <- results(ddsDE, alpha = 0.05, contrast=c("group", "One", "Zero"))
resTen <- results(ddsDE, alpha = 0.05, contrast=c("group", "Ten", "Zero"))
resHnd <- results(ddsDE, alpha = 0.05, contrast=c("group", "Hnd", "Zero"))


### Results column description
mcols(resOne)$description
## Adding significance DE column to the df results

# True DE results if padj<0.05 and absolute log2FoldChange > 1

# group one vs zero
resOne$DE <- ifelse(resOne$padj<0.05, "True", "False")
resOne[which(abs(resOne$log2FoldChange)<1),'DE'] <- "False"
resOne <- resOne[order(resOne$padj),]

# group ten vs zero
resTen$DE <- ifelse(resTen$padj <0.5, "True", "False")
resTen[which(abs(resTen$log2FoldChange) <1),'DE'] <- "False"
resTen <- resTen[order(resTen$padj), ]


# group hundred vs zero
resHnd$DE <- ifelse(resHnd$padj<0.05, "True", "False")
resHnd[which(abs(resHnd$log2FoldChange)<1),'DE'] <- "False"
resHnd <- resHnd[order(resHnd$padj),]



# saving res as a data frame
one <- as.data.frame(resOne)
ten <- as.data.frame(resTen)
hnd <- as.data.frame(resHnd)

## Creating a dataframe to save the results

#Dataframe with all results from deseq2
one$ID <- as.integer(rownames(one))
df1 <- left_join(count_matrix, one, by= "ID")
df1 <- df1 %>% relocate(ID, .before = peptide)
df1 <- rename(df1, "baseMean_1uM"=baseMean, "lfcSE_1uM"=lfcSE,"Log2FC_1uM"=log2FoldChange,
              "stat_1uM"=stat, "pvalue_1uM"=pvalue, "p.adj_1uM"=padj, "DE_1uM"=DE)



ten$ID <- as.integer(rownames(ten))
df10 <- left_join(df1, ten, by= "ID")
df10 <- df10 %>% relocate(ID, .before = peptide)
df10 <- rename(df10, "baseMean_10uM"=baseMean, "lfcSE_10uM"=lfcSE,"Log2FC_10uM"=log2FoldChange,
               "stat_10uM"=stat, "pvalue_10uM"=pvalue, "p.adj_10uM"=padj, "DE_10uM"=DE)


hnd$ID <- as.integer(rownames(hnd))
df_full <- left_join(df10, hnd, by= "ID")
df_full <- df_full %>% relocate(ID, .before = peptide)
df_full <- rename(df_full, "baseMean_100uM"=baseMean, "lfcSE_100uM"=lfcSE,"Log2FC_100uM"=log2FoldChange,
                  "stat_100uM"=stat, "pvalue_100uM"=pvalue, "p.adj_100uM"=padj, "DE_100uM"=DE)


# -------------------------------------------------------------------------------------------#
#                                 Download results tables
# -------------------------------------------------------------------------------------------#


### Results DESeq2
write.csv(df_full, 'results/res_full_deseq2.csv')


# # --------------------------------------------------------------------------------------------#
sessionInfo()


