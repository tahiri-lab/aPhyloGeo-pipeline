        
rule create_Matrix:
    output:
        newick = 'results/reference_tree/{feature}_newick'
    params:
        file_name = config['params']['geo_file'],
        df_geo = pd.read_csv(file_name)
    #conda: "../env/phylo.yaml"
    script:
        "../scripts/getGeotree.py"