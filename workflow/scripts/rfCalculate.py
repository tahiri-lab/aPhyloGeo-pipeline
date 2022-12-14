import os

"""
def rfNorm(rf_file):
    data = pd.read_csv(rf_file,sep='|')
    rf = float(data[' RF      '].iloc[1].strip())
    number_seq = int(data[' E.size  '].iloc[1].strip())
    return (rf/(2*number_seq-6))*100
"""
def rfCalcul(file_seqTree,file_refTree,ete3_output):
    if os.stat(file_seqTree).st_size == 0:   #if file_seqTree is empty, it means bootstrap < threshold
        open(ete3_output, 'w').close()    # create an empty file
    else:
        #os.system("ete3 compare -t " + file_seqTree + " -r " + file_refTree + " --unrooted >" + ete3_output)
        os.system("rf " + file_seqTree + " " + file_refTree + " > " + ete3_output)
        #with open(ete3_output, 'r') as file:
        #    normalized_rf = file.read().rstrip()
            #print("normalized_rf: ",normalized_rf)
        
        #if float(normalized_rf)*100 <= float(rf_threshold):
        #    with open("results/windows/rf_filtered.txt", "a") as f:
        #        f.write(file_seqTree[44:] + '\n')
   

if __name__ == '__main__':
    rfCalcul(snakemake.input.seq_tree,snakemake.input.ref_tree,snakemake.output.ete3_output)