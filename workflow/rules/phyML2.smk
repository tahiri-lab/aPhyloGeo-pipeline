
"""
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
"""
#-------------------------------------------------------
def update_yaml(yaml_file,params):
	windows_yaml = yaml_file
	with open(windows_yaml) as yamlfile:
		cur_yaml = yaml.safe_load(yamlfile)
		cur_yaml['windows_filtered'].append(params)
		#print(cur_yaml)
	with open(windows_yaml, 'w') as yamlfile:
		yaml.safe_dump(cur_yaml, yamlfile, explicit_start=True, allow_unicode=True, encoding='utf-8')
#-----------------------------------------------------
def filter_RF(wildcards):
    rf_outfile = checkpoints.rf_distance.get(position=wildcards.position, feature=wildcards.feature).output.ete3_output
    if os.stat(rf_outfile).st_size == 0: 
        #print("position_N",[wildcards][0][0])
        return "results/lowerBS/{position}.{feature}.rf_ete"
    else:
        with open(rf_outfile, 'r') as file:
            normalized_rf = file.read().rstrip()
        if float(normalized_rf)*100 <= float(config['Thresholds']['rf_threshold']):
            #print("position_Y",[wildcards][0][0])
            update_yaml("config/config.yaml",[wildcards][0][0])

            window_file = "results/windows/window_position_" + [wildcards][0][0] + ".fa"
            filtered_file = "results/windows_filter1/window_position_" + [wildcards][0][0] + ".fa"
            if not os.path.exists(filtered_file):
                shutil.copyfile(window_file,filtered_file) 
            return "results/lowerRF/{position}.{feature}.rf_ete"
        else:
            #print("position_N",[wildcards][0][0])
            return "results/higherRF/{position}.{feature}.rf_ete"

#rule calculRF:
#    input: expand("results/rf/{position}.{feature}.rf_ete", position = POS, feature=feature_names),

rule filterRF:
    input: filter_RF
    output: temp("results/filter1/{position}.{feature}")
    shell: "sleep 5; touch {output}"
           
rule lowerRF:
    input: "results/rf/{position}.{feature}.rf_ete"
    output: "results/lowerRF/{position}.{feature}.rf_ete"
    shell: "mv {input} {output}"

rule higherRF:
    input: "results/rf/{position}.{feature}.rf_ete"
    output: "results/higherRF/{position}.{feature}.rf_ete"
    shell: "mv {input} {output}"

rule lowerBS:
    input: "results/rf/{position}.{feature}.rf_ete"
    output: "results/lowerBS/{position}.{feature}.rf_ete"
    shell: "mv {input} {output}"

checkpoint rf_distance:
    input: seq_tree = "results/bootstrap_consensus/window_position_{position}",
           ref_tree = "results/reference_tree/{feature}_newick"
    output: ete3_output = "results/rf/{position}.{feature}.rf_ete",
    script:
        "../scripts/rfCalculate.py"

rule bootstrap_consensus:
    input: "results/windows/window_position_{position}.fa",
    output: temp("results/bootstrap_consensus/window_position_{position}"),
    script:
        "../scripts/bootstrapFilter.py"
#------------------------------------------------------------

