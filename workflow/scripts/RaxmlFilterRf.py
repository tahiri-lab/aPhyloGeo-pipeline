import os
from csv import writer


def addToCsv(window_pos, ref_feature, bootstrap_average, normalized_RF,output_csv):
    list = [window_pos, ref_feature, bootstrap_average, normalized_RF]
    with open(output_csv, 'a') as f_object:
        writer_object = writer(f_object)
        writer_object.writerow(list)
        f_object.close()

def rfFilter(file_seqTree,file_refTree,file_bootstrap_value,ete3_output,window_pos,ref_feature,rf_threshold =100):
    if os.stat(file_bootstrap_value).st_size == 0:   #if file_seqTree is empty, it means bootstrap < threshold
        open(ete3_output, 'w').close()    # create an empty file
    else:
        os.system("rf " + file_seqTree + " " + file_refTree + " > " + ete3_output)
        with open(ete3_output, 'r') as file:
            normalized_rf = file.read().rstrip()
        
        if float(normalized_rf)*100 <= float(rf_threshold):
            output_csv = "results/output_raxml.csv"
            with open(output_csv, "a") as f:
                normalized_RF = round(float(normalized_rf)*100,2)
                with open(file_bootstrap_value, 'r') as file:
                    bootstrap_average = round(float(file.read().rstrip()),2)
            addToCsv(window_pos, ref_feature, bootstrap_average, normalized_RF,output_csv)
                

if __name__ == '__main__':
    rfFilter(snakemake.input.seq_tree,snakemake.input.ref_tree,snakemake.input.bootstrap_value,snakemake.output.ete3_output,snakemake.wildcards.windows_pos,snakemake.wildcards.feature, snakemake.config['Thresholds']['rf_threshold'])
