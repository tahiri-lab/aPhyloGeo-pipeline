import pandas as pd
import subprocess
import os
from csv import writer
import time


def addToCsv(window_pos, ref_feature, bootstrap_average, normalized_RF):
    list = [window_pos, ref_feature, bootstrap_average, normalized_RF]
    #with open('output/filteredWindows'+ time.strftime("%Y%m%d-%H%M") + '.csv', 'a') as f_object:
    with open('output/filteredWindows_Raxml.csv', 'a') as f_object:
        writer_object = writer(f_object)
        writer_object.writerow(list)
        f_object.close()

def rfFilter(file_seqTree,file_refTree,file_bootstrap_value,ete3_output, rf_threshold =100):
    if os.stat(file_bootstrap_value).st_size == 0:   #if file_seqTree is empty, it means bootstrap < threshold
        open(ete3_output, 'w').close()    # create an empty file
    else:
        #os.system("ete3 compare -t " + file_seqTree + " -r " + file_refTree + " --unrooted >" + ete3_output)
        os.system("rf " + file_seqTree + " " + file_refTree + " > " + ete3_output)
        with open(ete3_output, 'r') as file:
            normalized_rf = file.read().rstrip()
        
        if float(normalized_rf)*100 <= float(rf_threshold):
            with open("results/windows/rf_filtered.txt", "a") as f:
                window_pos = file_seqTree[14:-15]
                ref_feature = file_refTree[16:-7]
                normalized_RF = round(float(normalized_rf)*100,2)
                with open(file_bootstrap_value, 'r') as file:
                    bootstrap_average = round(float(file.read().rstrip()),2)
            addToCsv(window_pos, ref_feature, bootstrap_average, normalized_RF)
                

if __name__ == '__main__':
    rfFilter(snakemake.input.seq_tree,snakemake.input.ref_tree,snakemake.input.bootstrap_value,snakemake.output.ete3_output, snakemake.config['Thresholds']['rf_threshold'])
