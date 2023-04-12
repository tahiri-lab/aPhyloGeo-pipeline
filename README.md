﻿﻿﻿﻿﻿﻿﻿<h1  align="center">🐍 Snakemake workflow: aPhyloGeo </h1> <p align='center'> 

[![Snakemake](https://img.shields.io/badge/snakemake-≥7.17.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/tahiri-lab/aPhyloGeo-pipeline/workflows/Tests/badge.svg?branch=main)](https://github.com/tahiri-lab/aPhyloGeo-pipeline/actions?query=branch%3Amain+workflow%3ATests)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 
[![Contributions](https://img.shields.io/badge/contributions-welcome-blue.svg)](https://pysd.readthedocs.io/en/latest/development/development_index.html)
[![Py version](https://img.shields.io/pypi/pyversions/pysd.svg)](https://pypi.python.org/pypi/pysd/)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Ftahiri-lab%2FaPhyloGeo-pipeline&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
[![GitHub release](https://img.shields.io/github/v/release/tahiri-lab/aPhyloGeo-pipeline.svg?maxAge=3600)](https://github.com/tahiri-lab/aPhyloGeo-pipeline/releases/)

</p>

<p align="justify">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; A Snakemake workflow for phylogeographic analysis.</p>

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
      <a href="#Usage">Getting started</a>
    </li>
    <li>
      <a href="#Citation">Citation</a>
    </li>
    <li>
      <a href="#contact">Contact</a>
    </li>
  </ol>
</details>


# 📝 About the project
<p align="justify">&nbsp;&nbsp;&nbsp;&nbsp;aPhyloGeo-pipeline is a user-friendly, scalable, reproducible, and comprehensive workflow that can explore how patterns of variation within species coincide with geographic features, such as climatic features.By incorporating user-defined parameters such as fragment size (window size) and sliding window advancement step (step size), the pipeline conducts a thorough scan of multiple sequence alignment (MSA) and performs a joint analysis with environmental data to identify gene fragments that are strongly associated with specific environmental factors.</p>

<p align="justify">&nbsp;&nbsp;&nbsp;&nbsp;To investigate the potential correlation between the diversity of specific genes or gene fragments and their geographic distribution, a sliding window strategy was employed in addition to traditional phylogenetic analyses. Firstly, the multiple sequence alignment (MSA) was partitioned into windows by specifying the sliding window size and step size. Then a phylogenetic tree for each window was constructed. Secondly, cluster analyses for each geographic factor were performed by calculating a distance matrix and creating a reference tree based on the distance matrix and the Neighbor-Joining clustering method (Cardoso et al., 2022). Reference trees (based on geographic factors) and phylogenetic trees (based on sliding windows) were defined on the same set of leaves (i.e., names of species). Subsequently, the correlation between phylogenetic and reference trees was evaluated using the Robinson and Foulds (RF) distance calculation. RF distances were calculated for each combination of the phylogenetic tree and the reference tree. Finally, bootstrap and RF thresholds were applied to identify gene fragments in which patterns of variation within species coincided with a particular geographic feature. These fragments can serve as informative reference points for future studies.</p>

# ⚒️ Dependencies

-   [Python](https://www.python.org/)
-   [Conda](https://conda.io/)  
-   [Snakemake](https://snakemake.readthedocs.io/)  

The workflow includes the following Python packages:
- [biopython](https://pypi.org/project/biopython/)
- [robinson-fould](https://pypi.org/project/robinson-foulds/)
- [numpy](https://pypi.org/project/numpy/)
- [pandas](https://pypi.org/project/pandas/)


The workflow includes the following bioinformatics tools:
- [raxml-ng](https://github.com/amkozlov/raxml-ng)
- [fasttree](http://www.microbesonline.org/fasttree/)

The software dependencies can be found in the [conda environment file](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/environment.yaml).

# 💡 Getting started 

**1. Clone this repo.**

    git clone https://github.com/tahiri-lab/aPhyloGeo-pipeline.git
    cd aPhyloGeo-pipeline


**2. 🚀 Install dependencies.** <br><br>
***2.1 If you do not have Conda installed, then use the following method to install it. If you already have Conda installed, then refer directly to the next step (2.2).***

    # download Miniconda3 installer
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    
    # install Conda (respond by 'yes')
    bash miniconda.sh
    
    # update Conda
    conda update -y conda
    
  
 ***2.2 Create a conda environment named aPhyloGeo and install all the dependencies in that environment.***<br>
 
 
    # create a new environment with dependencies 
    conda env create -n aPhyloGeo -f environment.yaml
    
    
 ***2.3 Activate the environment***   <br>
 
    conda activate aPhyloGeo
    
**3. Configure the workflow**

-   **Prepare the config file**:

	Modify the values of parameters and threshold in the [`config.yaml`](https://github.com/tahiri-lab/aPhyloGeo-pipeline/blob/main/config/config.yaml) according to the research needs.  <br>
	
	**Note**:  Please modify the corresponding values and do **NOT** change the parameter names or file names.

-   **Prepare the input files**:
	- A file of multiple sequences alignment in FASTA format
	- A CSV file includes environmental data on the geographical habitat of the studied species

**4. Execute the workflow.**

**Run workflow**

    
    # In a conda environment where all dependencies are already installed
    # Specify the maximum number of CPU cores to be used at the same time.
    # To use N cores: --cores N or -cN.
    
    snakemake --cores all
    
**Even with not created and activated the conda environment as required in 2.2 and 2.3 is possible by running the workflow successfully with '--use-conda'. Snakemake will create a temporary conda environment.**  <br>
    
    # To specify the maximum number of CPU cores to be used at the same time. 
    # 	With N cores: --cores N or -cN. 
    # 	For all cores in the system: --cores all. 
    
    snakemake --use-conda --cores all
    

# ✔️ Citation

1️⃣ A manuscript for aPhyloGeo-pipeline is in preparation.

2️⃣ The usage of this workflow is described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/?usage=tahiri-lab%2FaPhyloGeo-pipeline). If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) sitory and its DOI (see above).
	
# 📧 Contact
Please email us at : <Nadia.Tahiri@USherbrooke.ca> for any question or feedback.
