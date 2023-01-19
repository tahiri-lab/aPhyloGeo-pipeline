# Snakemake workflow: aPhyloGeo

[![Snakemake](https://img.shields.io/badge/snakemake-≥7.17.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/<owner>/<repo>/workflows/Tests/badge.svg?branch=main)](https://github.com/<owner>/<repo>/actions?query=branch%3Amain+workflow%3ATests)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 
[![Contributions](https://img.shields.io/badge/contributions-welcome-blue.svg)](https://pysd.readthedocs.io/en/latest/development/development_index.html)
[![Py version](https://img.shields.io/pypi/pyversions/pysd.svg)](https://pypi.python.org/pypi/pysd/)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Ftahiri-lab%2FaPhylogeo&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
[![GitHub release](https://img.shields.io/github/v/release/tahiri-lab/aPhylogeo.svg?maxAge=3600)](https://github.com/tahiri-lab/aPhylogeo/releases/)


A Snakemake workflow for phylogeographic analysis. 

aPhyloGeo is a user-friendly, scalable, reproducible, and comprehensive workflow that can explore the correlation between specific genes (or gene segments) and environmental factors.


## Dependencies

-   [Python](https://www.python.org/)
-   [Conda](https://conda.io/)  - package/environment management system
-   [Snakemake](https://snakemake.readthedocs.io/)  - workflow management system

The workflow includes the following Python packages:
- [biopython](https://pypi.org/project/biopython/)
- [robinson-fould](https://pypi.org/project/robinson-foulds/)
- [numpy](https://pypi.org/project/numpy/)
- [pandas](https://pypi.org/project/pandas/)


The workflow includes the following bioinformatics tools:
- [raxml-ng](https://github.com/amkozlov/raxml-ng)
- [fasttree](http://www.microbesonline.org/fasttree/)

The software dependencies can be found in the conda environment files: [[1]](https://github.com/tahiri-lab/aPhyloGeo-pipeline/tree/main/workflow/envs),[[2]](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/environment.yaml)

**1. Clone this repo.**

    git clone https://github.com/tahiri-lab/aPhyloGeo-pipeline.git
    cd aPhyloGeo-pipeline


**2. Install dependencies.**

    # download Miniconda3 installer
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    
    # install Conda (respond by 'yes')
    bash miniconda.sh
    
    # update Conda
    conda update -y conda
    
    # create a new environment with dependencies & activate it
    conda env create -n aphyloGeo -f environment.yaml
    conda activate aphyloGeo



**3. Configure the workflow.**

-   **config file**:
    
    -   [`config.yaml`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/config.yaml)  - analysis-specific settings (e.g., bootstrap_threshold, rf_threshold, step_size, window_size, data_type etc.) <br>
**Note**: You should set the parameters and threshold in the `config.yaml` file according to your research needs. When setting the parameters and threshold, please modify the corresponding values. Remember **not** to change the parameter names or file names.
	-   **Thresholds** in `config.yaml`:
		- bootstrap_threshold: Only sliding windows with bootstrap values greater than user-set bootstrap_threshold will be written to the output file.
		- rf_threshold: The tree distance between each combination of sliding windows and environmental features will be calculated. Only sliding windows with Robinson–Foulds (RF) distance below the user-set bootstrap_threshold will be written to the output file.
	-    **params** in `config.yaml`:
		- data_type: `aa` for the amino acid dataset (case insensitive); Any other values set by the user will be treated as nucleotide dataset (default).
		- geo_file:  the location of input file (the environmental data `.csv` )
		- seq_file:  the location of input file (the Multiple Sequence Alignment data `.fasta` )
		- specimen_id: the name of the column containing the sample id in `geo_file`
		- step_size: the size of the Sliding window movement step (bp)
		- window_size: the size of the Sliding window (bp)
		- strategy: For constructing the phylogenetic tree,  two alternative algorithms are provided, RAxML-Ng and FastTree. `fasttree` for the FastTree strategy (case insensitive); Any other values set by the user will be treated as RAxML-Ng strategy (default).
  
    
-   **input files**:
    
	   - **example data files for protein analysis**:
		    -  [`align_p.fa`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/align_p.fa)  - Multiple Sequence Alignment for protein sequences in `FASTA format`(5 samples).
		    -  [`geo_p.csv`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/geo_p.csv)  - Environmental data corresponding to sequencing samples (5 samples).
	 - **example data files for nucleotide analysis**:
	    -  	[`align.fa`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/align.fa)  - Multiple Sequence Alignment for nucleotide sequences in FASTA format (5 samples).
	    -   [`geo.csv`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/geo.csv)  - Environmental data corresponding to sequencing samples (5 samples).
    
-   **output files**:
    
    -   (filtered) sliding windows with Robinson–Foulds (RF) distance values below the user-set threshold and bootstrap values greater than the user-set threshold in  `.csv`  (comma-separated values files).
    

## Usage

The usage of this workflow is described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/?usage=<owner>%2F<repo>).

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) <repo>sitory and its DOI (see above).

