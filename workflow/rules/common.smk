import pandas as pd
import subprocess
import yaml
import os
import shutil
import numpy as np
from csv import writer
from itertools import groupby


#----------------------------------------------------
if not os.path.exists("results/RAxML"):
    os.makedirs("results/RAxML")

if not os.path.exists("results/output.csv"):
    columns_name = ["window_pos", "ref_feature", "bootstrap_average", "normalized_RF"]
    with open("results/output.csv", 'w') as f_object:
        writer_object = writer(f_object)
        writer_object.writerow(columns_name)
        f_object.close()
#-------------------------------

# global variable to use
file_name = config['params']['geo_file']
specimen_id = config['params']['specimen_id']
df_geo = pd.read_csv(file_name)
feature_names = config['params']['feature_names']

alignment_output = config['params']['seq_file']
window_size = config['params']['window_size']
step_size = config['params']['step_size']

#---------------------------------------------
def slidingWindow(alignment_output, win=0, step=0):
    # Check if mutation happens
    windows_mutation = []

    seq_lt = []

    fin = open(alignment_output, 'rb')

    faiter = (x[1] for x in groupby(fin, lambda line: str(line, 'utf-8')[0] == ">"))
    for header in faiter:
        #headerStr = str(header.__next__(), 'utf-8')
        #long_name = headerStr.strip().replace('>', '')
        #name = long_name.split()[0]
        seq = "".join(str(s, 'utf-8').strip() for s in faiter.__next__())
        #print(name, seq, long_name)
        seq_lt.append(seq)

    nt = [list(str(seq)) for seq in seq_lt]

    #nt = [list(str(seq_record.seq)) for seq_record in SeqIO.parse(alignment_output, "fasta")]
    seqDF = pd.DataFrame(nt)
    seqlen = seqDF.shape[1]
    for i in range(0,seqlen,step):
        j = seqlen if i+win>seqlen else i+win
        window = seqDF.iloc[:,i:j]
        window = window.replace('-', np.nan)
        window = window.dropna(axis = 0, how = 'all')
        distinctDF = window.drop_duplicates()
        #mutation happens
        if distinctDF.shape[0] > 1: 
            windows_mutation.append(str(i)+'_'+str(j))
        if j==seqlen: break
    return windows_mutation


POS = slidingWindow(alignment_output, window_size, step_size)

#---------------------------------------------
def get_windowedFilted(wildcards):
    rf_threshold = config['thresholds']['rf_threshold']
    strategy = config['params']['strategy']
    with checkpoints.rf_phyML.get().output[0].open() as f:
        qc = pd.read_csv(f)
        windows = qc[qc["normalized_RF"]<= rf_threshold]["window_pos"].to_list()
        windows_filtered = list(filter(None,set(windows)))
    if strategy.lower() != "fasttree":
        return expand("results/rf2/{windows_pos}.{feature}.rf_ete", windows_pos=windows_filtered,feature=feature_names)
    else: 
        return expand("results/rf2_fastTree/{windows_pos}.{feature}.rf_ete", windows_pos=windows_filtered,feature=feature_names)

