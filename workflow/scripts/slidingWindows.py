from Bio import SeqIO
import os
import pandas as pd
import numpy as np


def slidingWindow(alignment_output, win=0, step=0):
    #check whether the path exist or not
    isExist = os.path.isdir("output/windows")
    if not isExist:
        os.mkdir("output/windows")
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
            with open("output/windows/window_position_" + str(start) + "_" + str(end) + ".fa", "a") as handle:
                SeqIO.write(records, handle, "fasta") 
    #print(windows_mutation)              
    

if __name__ == '__main__':
    slidingWindow(snakemake.input[0], snakemake.config['params']['window_size'], snakemake.config['params']['step_size'])