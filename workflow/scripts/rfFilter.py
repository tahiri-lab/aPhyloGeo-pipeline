import os

def rfFilter(file_seqTree,file_refTree,ete3_output, rf_threshold =100):
    if os.stat(file_seqTree).st_size == 0:   #if file_seqTree is empty, it means bootstrap < threshold
        open(ete3_output, 'w').close()    # create an empty file
    else:
        #os.system("ete3 compare -t " + file_seqTree + " -r " + file_refTree + " --unrooted >" + ete3_output)
        os.system("rf " + file_seqTree + " " + file_refTree + " > " + ete3_output)
        with open(ete3_output, 'r') as file:
            normalized_rf = file.read().rstrip()
            #print("normalized_rf: ",normalized_rf)
        
        if float(normalized_rf)*100 <= float(rf_threshold):
            with open("results/rf_filtered_1.txt", "a") as f:
                f.write(file_seqTree[44:] + '\n')
     

if __name__ == '__main__':
    rfFilter(snakemake.input.seq_tree,snakemake.input.ref_tree,snakemake.output.ete3_output, snakemake.config['Thresholds']['rf_threshold'])