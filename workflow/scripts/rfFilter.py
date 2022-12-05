import os
import pandas as pd

"""
def rfNorm(rf_file):
    data = pd.read_csv(rf_file,sep='|')
    rf = float(data[' RF      '].iloc[1].strip())
    number_seq = int(data[' E.size  '].iloc[1].strip())
    return (rf/(2*number_seq-6))*100
"""
def rfFilter(file_seqTree,file_refTree,ete3_output, rf_threshold =100):
    if os.stat(file_seqTree).st_size == 0:   #if file_seqTree is empty, it means bootstrap < threshold
        open(ete3_output, 'w').close()    # create an empty file
    else:
        #os.system("ete3 compare -t " + file_seqTree + " -r " + file_refTree + " --unrooted >" + ete3_output)
        os.system("rf " + file_seqTree + " " + file_refTree + " > " + ete3_output)
        with open(ete3_output, 'r') as file:
            normalized_rf = file.read().rstrip()
        
        if float(normalized_rf)*100 <= rf_threshold:
            with open("output/windows/rf_filtered.txt", "a") as f:
                f.write(file_seqTree[43:] + '\n')
   

if __name__ == '__main__':
    rfFilter(snakemake.input.seq_tree,snakemake.input.ref_tree,snakemake.output.ete3_output, snakemake.config['Thresholds']['rf_threshold'])