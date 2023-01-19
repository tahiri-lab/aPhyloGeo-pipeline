
## General settings

To configure this workflow, modify config/config.yaml according to your needs, following the explanations provided in the file.




-   **config file**:
    
    -   [`config.yaml`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/config.yaml)  - analysis-specific settings (e.g., bootstrap_threshold, rf_threshold, step_size, window_size, data_type etc.) <br>
**Note**: You should set the parameters and threshold in the `config.yaml` file according to your research needs. When setting the parameters and threshold, please modify the corresponding values. Remember **not** to change the parameter names or file names.
	-   **Thresholds** in `config.yaml`:
		- `bootstrap_threshold`: Only sliding windows with bootstrap values greater than user-set bootstrap_threshold will be written to the output file.
		- `rf_threshold`: The tree distance between each combination of sliding windows and environmental features will be calculated. Only sliding windows with Robinson–Foulds (RF) distance below the user-set bootstrap_threshold will be written to the output file.
	-    **params** in `config.yaml`:
			- `data_type`: `aa` for the amino acid dataset (case insensitive); Any other values set by the user will be treated as nucleotide dataset (default).
			- `geo_file`:  the path of input file (the environmental data `.csv` )
			- `seq_file`:  the path of input file (the Multiple Sequence Alignment data `.fasta` ) <br>
		**Note**: If you want to use a Relative Path to describe the input file, you should use the path related to the `workflow` directory (i.e., the default Present Working Directory should be the `workflow`).
			- `specimen_id`: the name of the column containing the sample id in `geo_file`
			- `step_size`: the size of the Sliding window movement step (bp)
			- `window_size`: the size of the Sliding window (bp)
			- `strategy`: For constructing the phylogenetic tree,  two alternative algorithms are provided, RAxML-Ng and FastTree. `fasttree` for the FastTree strategy (case insensitive); Any other values set by the user will be treated as RAxML-Ng strategy (default).
  
    
-   **input files**:
    
	   - **example data files for protein analysis**:
		    -  [`align_p.fa`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/align_p.fa)  - Multiple Sequence Alignment for protein sequences in `FASTA format`(5 samples).
		    -  [`geo_p.csv`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/geo_p.csv)  - Environmental data corresponding to sequencing samples (5 samples).
	 - **example data files for nucleotide analysis**:
	    -  	[`align.fa`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/align.fa)  - Multiple Sequence Alignment for nucleotide sequences in FASTA format (5 samples).
	    -   [`geo.csv`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/geo.csv)  - Environmental data corresponding to sequencing samples (5 samples).
    
-   **output files**:
    
    -   (filtered) sliding windows with Robinson–Foulds (RF) distance values below the user-set threshold and bootstrap values greater than the user-set threshold in  `.csv`  (comma-separated values files).
    -  `.csv` and related metadata will be stored in the 'workflow/results' directory.
