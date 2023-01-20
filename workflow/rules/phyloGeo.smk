
#----------------------------------------------------

checkpoint rf_phyML: 
   input: expand("results/rf/{position}.{feature}.rf_ete", position = POS, feature=feature_names)
   output: "results/rf_phyML.csv"
   conda: "../envs/python.yaml"
   script: "../scripts/rfAfterPhyML.py"

rule qc_windows:
    output: 
        windows_filtered = "results/windows_filtered/window_filtered_{windows_pos}.fa"
    params: 
        alignment_output = config['params']['seq_file']
    conda: "../envs/biopython.yaml"
    script: "../scripts/getAlimentWindowsFiltered.py"   
#----------------------RaxML-NG-------------------------------------
rule runRaxML:
    input: "results/windows_filtered/window_filtered_{windows_pos}.fa"
    output: 
            temp("results/RAxML/{windows_pos}.raxml.bestModel"),
            "results/RAxML/{windows_pos}.raxml.bestTree",
            temp("results/RAxML/{windows_pos}.raxml.bootstraps"),
            temp("results/RAxML/{windows_pos}.raxml.log"),
            temp("results/RAxML/{windows_pos}.raxml.mlTrees"),
            temp("results/RAxML/{windows_pos}.raxml.rba"),
            temp("results/RAxML/{windows_pos}.raxml.startTree"),
            temp("results/RAxML/{windows_pos}.raxml.support"),
    params: data_type = config['params']['data_type']
    conda: "../envs/raxML.yaml"
    script:
        "../scripts/runRaxMl.py"

rule bootstrapFilter2:
    input: "results/RAxML/{windows_pos}.raxml.bestTree"
    output: "results/RaxMLBootstrap/{windows_pos}.raxmlBootstrap"
    conda: "../envs/numpy.yaml"
    script:
        "../scripts/FilterBootstrap2.py"

rule rf_distance2:
    input: seq_tree = "results/RAxML/{windows_pos}.raxml.bestTree",
           ref_tree = "results/reference_tree/{feature}_newick",
           bootstrap_value = "results/RaxMLBootstrap/{windows_pos}.raxmlBootstrap"
    output: ete3_output = "results/rf2/{windows_pos}.{feature}.rf_ete",
    conda: "../envs/rf.yaml"
    script:
        "../scripts/FilterRf2.py"

#----------------------FastTree-------------------------------------
rule runFasttree:
    input: "results/windows_filtered/window_filtered_{windows_pos}.fa"
    output: "results/fastTree/window_filtered.{windows_pos}.fastTree"
    params: data_type = config['params']['data_type']
    conda: "../envs/fastTree.yaml"
    script:
        "../scripts/runFastTree.py"


rule bootstrapFilter_fasttree:
    input: "results/fastTree/window_filtered.{windows_pos}.fastTree"
    output: "results/fastTreeBootstrap/{windows_pos}.fastTreeBootstrap"
    conda: "../envs/numpy.yaml"
    script:
        "../scripts/FilterBootstrap2.py"

rule rf_distance_fasttree:
    input: seq_tree = "results/fastTree/window_filtered.{windows_pos}.fastTree",
           ref_tree = "results/reference_tree/{feature}_newick",
           bootstrap_value = "results/fastTreeBootstrap/{windows_pos}.fastTreeBootstrap"
    output: ete3_output = "results/rf2_fastTree/{windows_pos}.{feature}.rf_ete",
    conda: "../envs/rf.yaml"
    script:
        "../scripts/FilterRf2.py"


  