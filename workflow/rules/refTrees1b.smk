import pandas as pd
import subprocess
import os

file_name = config['params']['geo_file']
specimen_id = config['params']['specimen_id']
df_geo = pd.read_csv(file_name)
feature_names = list(df_geo.columns)[1:]


rule all:
    input:expand('results/reference_tree/{feature}_newick', feature=feature_names)
        
rule create_Matrix:
    output:
        newick = 'results/reference_tree/{feature}_newick'
    params:
        file_name = config['params']['geo_file'],
        df_geo = pd.read_csv(file_name)
    script:
        "../scripts/getGeotree.py"