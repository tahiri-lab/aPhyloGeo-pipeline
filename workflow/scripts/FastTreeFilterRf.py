import pandas as pd
import os
from csv import writer



def addToCsv(window_pos, ref_feature, bootstrap_average, normalized_RF):
    list = [window_pos, ref_feature, bootstrap_average, normalized_RF]
    with open('output/filteredWindows_fastTree.csv', 'a') as f_object:
        writer_object = writer(f_object)
        writer_object.writerow(list)
        f_object.close()

def rfFilter(file_seqTree,file_refTree,file_bootstrap_value,ete3_output, rf_threshold =100):
    if os.stat(file_bootstrap_value).st_size == 0:   #if file_seqTree is empty, it means bootstrap < threshold
        open(ete3_output, 'w').close()    # create an empty file
       #open(completed_check, "w").close()
    else:
        #os.system("ete3 compare -t " + file_seqTree + " -r " + file_refTree + " --unrooted >" + ete3_output)
        os.system("rf " + file_seqTree + " " + file_refTree + " > " + ete3_output)
        with open(ete3_output, 'r') as file:
            normalized_rf = file.read().rstrip()
        
        if float(normalized_rf)*100 <= rf_threshold:
            with open("output/windows/rf_filtered.txt", "a") as f:
                window_pos = file_seqTree[32:-9]
                ref_feature = file_refTree[15:-7]
                normalized_RF = round(float(normalized_rf)*100,2)
                with open(file_bootstrap_value, 'r') as file:
                    bootstrap_average = round(float(file.read().rstrip()),2)
            addToCsv(window_pos, ref_feature, bootstrap_average, normalized_RF)
            #open(completed_check, "w").close()
        #else:
            #open(completed_check, "w").close() 
                

if __name__ == '__main__':
    rfFilter(snakemake.input.seq_tree,snakemake.input.ref_tree,snakemake.input.bootstrap_value,snakemake.output.ete3_output,snakemake.config['Thresholds']['rf_threshold'])
