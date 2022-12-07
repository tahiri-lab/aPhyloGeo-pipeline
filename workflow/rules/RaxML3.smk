import os

if not os.path.exists("results/RAxML"):
    os.makedirs("results/RAxML")

with open("results/windows/rf_filtered.txt") as f:
	data = f.read()
window_filt_phyML = list(filter(None,set(data.split("\n"))))

ref_feature, = glob_wildcards("reference_tree/{ref}_newick")


rule all:
    input: expand("results/rf2/{windowFilted}.{ref}.rf_ete", windowFilted=window_filt_phyML,ref = ref_feature),
         
rule rf_distance:
    input: seq_tree = "results/RAxML/{windowFilted}.raxml.bestTree",
           ref_tree = "results/reference_tree/{ref}_newick",
           bootstrap_value = "results/RaxBootstrap/{windowFilted}.raxmlBootstrap"
    output: ete3_output = temp("results/rf2/{windowFilted}.{ref}.rf_ete")
    script:
        "../scripts/RaxmlFilterRf.py"

rule bootstrapFilter:
    input: "results/RAxML/{windowFilted}.raxml.bestTree"
    output: temp("results/RaxBootstrap/{windowFilted}.raxmlBootstrap")
    script:
        "../scripts/RaxFilterBootstrap.py"

rule runRaxML:
    input:  "results/windows/window_position_{windowFilted}.fa"
    output: 
            temp("results/RAxML/{windowFilted}.raxml.bestModel"),
            temp("results/RAxML/{windowFilted}.raxml.bestTree"),
            temp("results/RAxML/{windowFilted}.raxml.bootstraps"),
            temp("results/RAxML/{windowFilted}.raxml.log"),
            temp("results/RAxML/{windowFilted}.raxml.mlTrees"),
            temp("results/RAxML/{windowFilted}.raxml.rba"),
            temp("results/RAxML/{windowFilted}.raxml.startTree"),
            temp("results/RAxML/{windowFilted}.raxml.support"),
    run:
        os.system("raxml-ng --all --model GTR+G --msa " + input[0] + " --prefix results/RaxMl/" + wildcards.windowFilted + " --msa-format FASTA --data-type DNA --tree pars{5} --seed 239 --threads 2 --force --bs-trees 100 --bs-metric fbp")
       
