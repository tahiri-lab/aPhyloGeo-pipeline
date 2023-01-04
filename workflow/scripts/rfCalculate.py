import os

def rfCalcul(file_seqTree,file_refTree,ete3_output):
    if os.stat(file_seqTree).st_size == 0:   #if file_seqTree is empty, it means bootstrap < threshold
        open(ete3_output, 'w').close()    # create an empty file
    else:
        os.system("rf " + file_seqTree + " " + file_refTree + " > " + ete3_output)
         

if __name__ == '__main__':
    rfCalcul(snakemake.input.seq_tree,snakemake.input.ref_tree,snakemake.output.ete3_output)