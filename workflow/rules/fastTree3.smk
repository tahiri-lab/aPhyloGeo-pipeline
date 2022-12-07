import os

if not os.path.exists("results/RAxML"):
    os.makedirs("results/RAxML")

with open("results/windows/rf_filtered.txt") as f:
	data = f.read()
window_filt_phyML = list(filter(None,set(data.split("\n"))))

ref_feature, = glob_wildcards("results/reference_tree/{ref}_newick")

rule all:
    input: expand("results/rf2_fastTree/{windowFilted}.{ref}.rf_ete", windowFilted=window_filt_phyML,ref = ref_feature)
           
         
rule rf_distance:
    input: seq_tree = "results/fastTree/window_position.{windowFilted}.fastTree",
           ref_tree = "results/reference_tree/{ref}_newick",
           bootstrap_value = "results/fastTreeBootstrap/{windowFilted}.fastTreeBootstrap"
    output: ete3_output =  temp("results/rf2_fastTree/{windowFilted}.{ref}.rf_ete"),
    script:
        "../scripts/FastTreeFilterRf.py"

rule bootstrapFilter:
    input: "results/fastTree/window_position.{windowFilted}.fastTree"
    output: temp("results/fastTreeBootstrap/{windowFilted}.fastTreeBootstrap")
    script:
        "../scripts/RaxFilterBootstrap.py"

rule fasttree:
    input:
        alignment="results/windows/window_position_{windowFilted}.fa",  # Input alignment file
    output:
        tree=temp("results/fastTree/window_position.{windowFilted}.fastTree"),  # Output tree file
    log:
        "logs/muscle_FastTree/{windowFilted}.log",
    wrapper:
        "v1.14.1-3-g76174cf/bio/fasttree"