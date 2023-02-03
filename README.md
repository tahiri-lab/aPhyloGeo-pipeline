﻿﻿﻿﻿﻿﻿﻿<h1  align="center"> Snakemake workflow: aPhyloGeo </h1> <p align='center'> 

[![Snakemake](https://img.shields.io/badge/snakemake-≥7.17.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/tahiri-lab/aPhyloGeo-pipeline/workflows/Tests/badge.svg?branch=main)](https://github.com/tahiri-lab/aPhyloGeo-pipeline/actions?query=branch%3Amain+workflow%3ATests)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 
[![Contributions](https://img.shields.io/badge/contributions-welcome-blue.svg)](https://pysd.readthedocs.io/en/latest/development/development_index.html)
[![Py version](https://img.shields.io/pypi/pyversions/pysd.svg)](https://pypi.python.org/pypi/pysd/)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Ftahiri-lab%2FaPhyloGeo-pipeline&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
[![GitHub release](https://img.shields.io/github/v/release/tahiri-lab/aPhyloGeo-pipeline.svg?maxAge=3600)](https://github.com/tahiri-lab/aPhyloGeo-pipeline/releases/)

</p>

<p align="justify">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A Snakemake workflow for phylogeographic analysis make by Wanlin Li and Tahiri Nadia from University of Sherbrooke (Quebec, Canada).</p>

<details open>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About the project</a>
    </li>
    <li>
      <a href="#Dependencies">Dependencies</a>
    </li>
    <li>
      <a href="#Usage">Usage</a>
    </li>
    <li>
      <a href="#Citation">Citation</a>
    </li>
    <li>
      <a href="#contact">Contact</a>
    </li>
  </ol>
</details>


# About the project
A Snakemake workflow for phylogeographic analysis make by Wanlin Li and Tahiri Nadia from University of Sherbrooke (Quebec, Canada). 
<p align="justify">&nbsp;&nbsp;&nbsp;&nbsp;aPhyloGeo-pipeline is a user-friendly, scalable, reproducible, and comprehensive workflow that can explore the correlation between specific genes (or gene segments) and environmental factors.</p>

<p align="justify">&nbsp;&nbsp;&nbsp;&nbsp;To investigate the possible correlation between the diversity of specific genes (or gene fragments) and the geographical distribution of these species, (1) we first added the strategy of sliding windows to the traditional phylogeny study. By setting the sliding window size and step size, the alignment of multiple sequences was cut into windows, and a phylogenetic tree was constructed for each window. (2) A cluster analysis was performed for each geographical factor. For each geographical factor, a distance matrix was calculated, and then a reference tree was created based on the distance matrix and neighbour-joining clustering method. The leaf nodes of these reference trees correspond to the environmental factors of the species involved in the phylogenetic trees. (3) Subsequently, the correlations between phylogenetic and reference trees were evaluated using the Robinson-Foulds (RF) distance calculation. RF distances were calculated for each combination of the phylogenetic tree and the reference tree. (4) Eventually, thresholds were used to screen out gene fragments in which patterns of variation within species coincide with a specific geographic feature. These screened fragments can provide meaningful reference information for further studies.</p>

# Dependencies

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

The software dependencies can be found in the conda environment files: [[1]](https://github.com/tahiri-lab/aPhyloGeo-pipeline/tree/main/workflow/envs) and [[2]](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/environment.yaml).

# Usage 

**1. Clone this repo.**

    git clone https://github.com/tahiri-lab/aPhyloGeo-pipeline.git
    cd aPhyloGeo-pipeline


**2. Install dependencies.** <br><br>
**2.1 If you do not have Conda installed, then use the following method to install it. If you already have Conda installed, then refer directly to the next step (2.2).**

    # download Miniconda3 installer
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    
    # install Conda (respond by 'yes')
    bash miniconda.sh
    
    # update Conda
    conda update -y conda
    
  
 **2.2 Create a conda environment named aPhyloGeo and install all the dependencies in that environment.**<br>
 
 
    # create a new environment with dependencies 
    conda env create -n aPhyloGeo -f environment.yaml
    
    
 **2.3 Activate the environment**   <br>
 
    conda activate aPhyloGeo



**3. Configure the workflow.**

-   **config file**:
    
    -   [`config.yaml`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/config.yaml)  - analysis-specific settings (e.g., bootstrap_threshold, rf_threshold, step_size, window_size, data_type etc.) <br>
**Note**:You should set the parameters and threshold in the `config.yaml` file according to your research needs. When setting the parameters and threshold, please modify the corresponding values. Remember **not** to change the parameter names or file names.
	-   **Thresholds** in `config.yaml`:
		- `bootstrap_threshold`: Only sliding windows with bootstrap values greater than user-set bootstrap_threshold (value from 0 to 1) will be written to the output file.
		- `rf_threshold`: The tree distance between each combination of sliding windows and environmental features will be calculated. Only sliding windows with Robinson–Foulds (RF) distance below the user-set rf_threshold (value from 0 to 100) will be written to the output file.
	-    **params** in `config.yaml`:
			- `data_type`: `aa` for the amino acid dataset (case insensitive); Any other values set by the user will be treated as nucleotide dataset (default).
			- `step_size`: the size of the Sliding window movement step (bp)
			- `window_size`: the size of the Sliding window (bp)
			- `strategy`: For constructing the phylogenetic tree,  two alternative algorithms are provided, RAxML-Ng and FastTree. `fasttree` for the FastTree strategy (case insensitive); Any other values set by the user will be treated as RAxML-Ng strategy (default).
			- `geo_file`:  the path of input file (the environmental data `.csv` )
			- `seq_file`:  the path of input file (the Multiple Sequence Alignment data `.fasta` ) <br>
		**Note**: If you want to use a Relative Path to describe the input file, you should use the path related to the `aPhyloGeo-pipeline` directory (i.e., the default Present Working Directory should be the `workflow`).<br>
			- `specimen_id`: the name of the column containing the sample id in `geo_file`
			- `feature_names`: The names of the columns corresponding to the environmental factors that will be involved in the analysis (in `geo_file`) <br>
		**Note**: Each column name is on a separate line, don't forget to keep the "-" in front of it.
  
    
-   **input files**:
    
	   - **example data files for protein analysis**:
		    -  [`align_p.fa`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/align_p.fa)  - Multiple Sequence Alignment for protein sequences in `FASTA format`(5 samples).
		    -  [`geo_p.csv`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/geo_p.csv)  - Environmental data corresponding to sequencing samples (5 samples).
	 - **example data files for nucleotide analysis**:
	    -  	[`align.fa`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/align.fa)  - Multiple Sequence Alignment for nucleotide sequences in FASTA format (5 samples).
	    -   [`geo.csv`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/geo.csv)  - Environmental data corresponding to sequencing samples (5 samples).
    
-   **output files**:
    
    -   (filtered) sliding windows with Robinson–Foulds (RF) distance values below the user-set threshold and bootstrap values greater than the user-set threshold in  `.csv`  (comma-separated values files).
    -  `.csv` and related metadata will be stored in the 'results' directory.


**4. Execute the workflow.**


_Locally_  <br>

**run workflow**

    
    # If you are in a conda environment where all dependencies are already installed
    # you need to specify the maximum number of CPU cores to be used at the same time.
    # If you want to use N cores, say --cores N or -cN.
    
    snakemake --cores all
    
**Even if you have not created and activated the conda environment as required in 2.2 and 2.3, you can still run workflow successfully with '--use-conda'. Snakemake will create a temporary conda environment for you**  <br>
    
    #you need to specify the maximum number of CPU cores to be used at the same time. 
    #If you want to use N cores, say --cores N or -cN. 
    #For all cores on your system (be sure that this is appropriate) use --cores all. 
    
    snakemake --use-conda --cores all
    
**Other features available**  <br>

    
    # 'dry' run only checks I/O files
    
    snakemake -n
    
    # 'dry-run' print shell commands
    
    snakemake -np
    
    # force snakemake to run the job. By default, if snakemake thinks the pipeline doesn’t need updating, snakemake will not run
    
    snakemake -F
    

## Usage (Option 2)

The usage of this workflow is described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/?usage=tahiri-lab%2FaPhyloGeo-pipeline).

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) <repo>sitory and its DOI (see above).


# Citation

A manuscript for aPhyloGeo-pipeline is in preparation.
	
	
# Contact
Please email us at : <Nadia.Tahiri@USherbrooke.ca> for any question or feedback.
