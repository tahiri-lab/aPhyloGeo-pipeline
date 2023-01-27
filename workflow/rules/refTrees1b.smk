        
rule create_Matrix:
    output:
        newick = 'results/reference_tree/{feature}_newick'
    params:
        file_name = config['params']['geo_file'],
        df_geo = pd.read_csv(file_name)
    conda: "../envs/phylo.yaml"
    log: "logs/create_Matrix/{feature}.log"
    script:
        "../scripts/getGeotree.py"