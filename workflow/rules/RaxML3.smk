

         
rule rf_distance2:
    input: seq_tree = "results/RAxML/{windows_pos}.raxml.bestTree",
           ref_tree = "results/reference_tree/{geo_feature}_newick",
           bootstrap_value = "results/RaxBootstrap/{windows_pos}.raxmlBootstrap"
    output: ete3_output = temp("results/rf2/{windows_pos}.{geo_feature}.rf_ete"),
    script:
        "../scripts/RaxmlFilterRf.py"

rule bootstrapFilter2:
    input: "results/RAxML/{windows_pos}.raxml.bestTree"
    output: temp("results/RaxBootstrap/{windows_pos}.raxmlBootstrap")
    script:
        "../scripts/RaxFilterBootstrap.py"

rule runRaxML:
    input:  "results/windows/window_position_{windows_pos}.fa"
    output: 
            temp("results/RAxML/{windows_pos}.raxml.bestModel"),
            temp("results/RAxML/{windows_pos}.raxml.bestTree"),
            temp("results/RAxML/{windows_pos}.raxml.bootstraps"),
            temp("results/RAxML/{windows_pos}.raxml.log"),
            temp("results/RAxML/{windows_pos}.raxml.mlTrees"),
            temp("results/RAxML/{windows_pos}.raxml.rba"),
            temp("results/RAxML/{windows_pos}.raxml.startTree"),
            temp("results/RAxML/{windows_pos}.raxml.support"),
    run:
        os.system("raxml-ng --all --model GTR+G --msa " + input[0] + " --prefix results/RaxMl/" + wildcards.windowFilted + " --msa-format FASTA --data-type DNA --tree pars{5} --seed 239 --threads 2 --force --bs-trees 100 --bs-metric fbp")
       
   