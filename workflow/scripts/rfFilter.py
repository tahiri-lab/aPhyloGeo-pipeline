import os, yaml

"""
def rfNorm(rf_file):
    data = pd.read_csv(rf_file,sep='|')
    rf = float(data[' RF      '].iloc[1].strip())
    number_seq = int(data[' E.size  '].iloc[1].strip())
    return (rf/(2*number_seq-6))*100

def get_windowFilterList(filter_txt):
    with open(filter_txt) as f:
        data = f.read()
    return list(filter(None,set(data.split("\n"))))

def update_yaml(yaml_file,list_params):
	windows_yaml = yaml_file

	with open(windows_yaml) as yamlfile:
		cur_yaml = yaml.safe_load(yamlfile)
		cur_yaml['windows_filtered'] = list_params
		#print(cur_yaml)
	with open(windows_yaml, 'w') as yamlfile:
		yaml.safe_dump(cur_yaml, yamlfile, explicit_start=True, allow_unicode=True, encoding='utf-8')
"""

def rfFilter(file_seqTree,file_refTree,ete3_output, rf_threshold =100):
    if os.stat(file_seqTree).st_size == 0:   #if file_seqTree is empty, it means bootstrap < threshold
        open(ete3_output, 'w').close()    # create an empty file
    else:
        #os.system("ete3 compare -t " + file_seqTree + " -r " + file_refTree + " --unrooted >" + ete3_output)
        os.system("rf " + file_seqTree + " " + file_refTree + " > " + ete3_output)
        with open(ete3_output, 'r') as file:
            normalized_rf = file.read().rstrip()
            #print("normalized_rf: ",normalized_rf)
        
        if float(normalized_rf)*100 <= float(rf_threshold):
            with open("results/rf_filtered_1.txt", "a") as f:
                f.write(file_seqTree[44:] + '\n')
        # add windows list into the yaml file (filter_list.yaml)
        #list_params = get_windowFilterList(windows_filtered)
        #update_yaml("config/filter_list.yaml",list_params)
#snakemake.output.windows_filtered,

if __name__ == '__main__':
    rfFilter(snakemake.input.seq_tree,snakemake.input.ref_tree,snakemake.output.ete3_output, snakemake.config['Thresholds']['rf_threshold'])