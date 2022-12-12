

rule rf_distance:
    input: seq_tree = "results/bootstrap_consensus/window_position_{position}",
           ref_tree = 'results/reference_tree/{feature}_newick'
    output: ete3_output = temp("results/rf/{position}.{feature}.rf_ete")
    script:
        "../scripts/rfFilter.py"

rule bootstrap_consensus:
    input: "results/windows/window_position_{position}.fa",
    output: temp("results/bootstrap_consensus/window_position_{position}"),
    script:
        "../scripts/bootstrapFilter.py"
