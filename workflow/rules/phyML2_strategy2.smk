configfile: "config/config.yaml"

import pandas as pd
import subprocess
import os
from Bio import SeqIO
import os
import numpy as np

#---------------------------------------------
def slidingWindow(alignment_output, win=0, step=0):
    #check whether the path exist or not
    window_dir = "results/windows/"
    isExist = os.path.isdir(window_dir)
    if not isExist:
        os.mkdir(window_dir)
    else:
        filelist = [f for f in os.listdir(window_dir) if f.endswith(".fa") ]
        for f in filelist:
            os.remove(os.path.join(window_dir, f))
    # Check if mutation happens
    windows_mutation = []

    nt = [list(str(seq_record.seq)) for seq_record in SeqIO.parse(alignment_output, "fasta")]
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
            #print(distinctDF.shape[0])
            #print("mutation window detected: {}_{}".format(i,j))
            windows_mutation.append((i,j))
            #print(i,j)
        if j==seqlen: break
    # write the sequence of sliding window which have mutation detected in fasta file
    for seq_record in SeqIO.parse(alignment_output, "fasta"):
        for start, end in windows_mutation:
            #print(start,end)
            records = seq_record[start:end]
            with open("results/windows/window_position_" + str(start) + "_" + str(end) + ".fa", "a") as handle:
                SeqIO.write(records, handle, "fasta") 

#----------------------------------------------------
#-------------------------------
# global variable to use
file_name = config['params']['geo_file']
specimen_id = config['params']['specimen_id']
df_geo = pd.read_csv(file_name)
feature_names = list(df_geo.columns)[1:]

alignment_output = config['params']['seq_file']
window_size = config['params']['window_size']
step_size = config['params']['step_size']

#---------------------------------------------
# step 1a: Sliding windows
slidingWindow(alignment_output, window_size, step_size)

# step 1b: Reference trees construction
include: 'refTrees1b.smk'

POS, = glob_wildcards("results/windows/window_position_{position}.fa")
#print("POS: ",POS)
#------------------------------------
rule first_filter:
    input: expand("results/rf/{position}.{feature}.rf_ete", position = POS, feature=feature_names)
    priority:50


rule rf_distance:
    input: seq_tree = "results/bootstrap_consensus/window_position_{position}",
           ref_tree = 'results/reference_tree/{feature}_newick'
    output: ete3_output = temp("results/rf/{position}.{feature}.rf_ete")
    script:
        "../scripts/rfFilter.py"

rule bootstrap_consensus:
    input: "results/windows/window_position_{position}.fa",
    output: temp("results/bootstrap_consensus/window_position_{position}"),
    script:
        "../scripts/bootstrapFilter.py"