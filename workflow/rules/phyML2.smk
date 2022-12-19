
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
    output: ete3_output = "results/rf/{position}.{feature}.rf_ete"
    script:
        "../scripts/rfCalculate.py"

rule bootstrap_consensus:
    input: "results/windows/window_position_{position}.fa",
    output: temp("results/bootstrap_consensus/window_position_{position}"),
    script:
        "../scripts/bootstrapFilter.py"
#------------------------------------------------------------

