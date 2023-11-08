#!/usr/bin/env python3 -u
# # Deep mutational scanning and machine learning uncover antimicrobial peptide features driving membrane selectivity

# ## Part 2 - Translate the peptide sequences and compute changes in the residues

import pandas as pd
from Bio.Seq import Seq

# Load  count matrix 
counts = pd.read_table("data/counts/count_matrix.txt", sep="\s+", engine="python", header=None)

# rename columns
counts.rename(columns={0:"Sequence", 1:'S01_0uM_IPTG_1', 2:'S02_0uM_IPTG_2', 3:'S03_0uM_IPTG_3',
       4:'S04_1uM_IPTG_1', 5:'S05_1uM_IPTG_2', 6:'S06_1uM_IPTG_3', 7:'S07_10uM_IPTG_1',
       8:'S08_10uM_IPTG_2', 9:'S09_10uM_IPTG_3', 10:'S10_100uM_IPTG_1',
       11:'S11_100uM_IPTG_2', 12:'S12_100uM_IPTG_3'}, inplace=True)



################################## Translate nucleotide sequence ##################################
# Translate nucleotide sequence to amino acid sequence
counts['peptide'] = ["".join(Seq(sq).translate(to_stop=True)) for sq in counts["Sequence"]]

################################### Stacking read counts ###################################

# This stacked dataframe will be used to compute diferencial expression analysis for each peptide.

# Stacking (sum) all the read counts that translate the same peptide
cols = ['S01_0uM_IPTG_1', 'S02_0uM_IPTG_2', 'S03_0uM_IPTG_3',
       'S04_1uM_IPTG_1', 'S05_1uM_IPTG_2', 'S06_1uM_IPTG_3', 'S07_10uM_IPTG_1',
       'S08_10uM_IPTG_2', 'S09_10uM_IPTG_3', 'S10_100uM_IPTG_1',
       'S11_100uM_IPTG_2', 'S12_100uM_IPTG_3']

df_stacked = counts.groupby(["peptide"], as_index=False)[cols].sum().copy()


# adding pep length column
df_stacked.insert(2, 'len_pep', df_stacked.peptide.str.len())
df_stacked = df_stacked.query('len_pep == 18').copy()


# creating columns with mean df_stacked for each group
df_stacked["Mean_0IPTG_reads"] = ((df_stacked['S01_0uM_IPTG_1'] + df_stacked['S02_0uM_IPTG_2'] + df_stacked['S03_0uM_IPTG_3']) /3).round()
df_stacked["Mean_1IPTG_reads"] = ((df_stacked['S04_1uM_IPTG_1'] + df_stacked['S05_1uM_IPTG_2'] + df_stacked['S06_1uM_IPTG_3']) /3).round()
df_stacked["Mean_10IPTG_reads"] = ((df_stacked['S07_10uM_IPTG_1'] + df_stacked['S08_10uM_IPTG_2'] + df_stacked['S09_10uM_IPTG_3']) /3).round()
df_stacked["Mean_100IPTG_reads"] = ((df_stacked['S10_100uM_IPTG_1'] + df_stacked['S11_100uM_IPTG_2'] + df_stacked['S12_100uM_IPTG_3']) /3).round()


######################### Creating functions to compare peptides #########################

# def to find the differences between the residues
idx = "RRRRICYCPLRFYVCVGR"

def diff_func(idxx):
    pg1 = "RGGRLCYCRRRFCVCVGR"
    idx = idxx
    diff = []
    for i in range(0, len(pg1)):
        aa = idx[i]
        pg_aa = pg1[i]
        
        if pg_aa == aa:
            diff.append("-")
        else:
            diff.append(aa)
    diff_seq = "".join(diff)
    return diff_seq


# function to add the number of changes in each peptide
def changesFunc(idxx):
    pg1 = "RGGRLCYCRRRFCVCVGR"
    idx = idxx
    changes = 0
    for i in range(0, len(pg1)):
        aa = idx[i]
        pg_aa = pg1[i]
        
        if pg_aa != aa:
            changes+=1
    return changes


#############################################################################################
#                         Applying changes into the new data frame 
#############################################################################################

# applying functions
df_stacked["diff_in_seq"] = [diff_func(x) for x in df_stacked["peptide"]]
df_stacked["changes"] = [changesFunc(x) for x in df_stacked["peptide"]]

# Merging dataframes
new_diff = df_stacked["diff_in_seq"].str.split("", n= -1, expand = True)
new_df_stacked = pd.merge(df_stacked, new_diff, left_index=True, right_index=True)
new_df_stacked.reset_index(drop=False, inplace=True)


# rename columns positions
new_cols = {'index':'ID', 0:'P0', 1:'P1', 2:'P2', 3:'P3', 4:'P4', 5:'P5', 6:'P6', 7:'P7', 8:'P8', 9:'P9', 10:'P10', 11:'P11', 12:'P12', 13:'P13', 14:'P14', 15:'P15', 16:'P16', 17:'P17', 18:'P18', 19:'P19'}
new_df_stacked.rename(columns=new_cols, inplace=True)


# Filtring just the columns of interest
cols = ['ID', 'peptide', 'len_pep', 'diff_in_seq', 'changes',"P1","P2","P3","P4","P5","P6","P7","P8","P9","P10","P11","P12","P13","P14","P15","P16","P17","P18",
        'Mean_0IPTG_reads','Mean_1IPTG_reads', 'Mean_10IPTG_reads', 'Mean_100IPTG_reads', 
        'S01_0uM_IPTG_1', 'S02_0uM_IPTG_2', 'S03_0uM_IPTG_3',
        'S04_1uM_IPTG_1', 'S05_1uM_IPTG_2', 'S06_1uM_IPTG_3',
        'S07_10uM_IPTG_1', 'S08_10uM_IPTG_2','S09_10uM_IPTG_3',
        'S10_100uM_IPTG_1', 'S11_100uM_IPTG_2','S12_100uM_IPTG_3'
        ]
new_df_stacked = new_df_stacked[cols]


#### Saving results #### 
print('Saving results...')
new_df_stacked.to_csv("data/counts/counts_matrix_stacked.csv", header=True, index=False)

#### The End ####
print('Done!')


