FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="9bb0deaa8bc3d0c0b5b61cebd4e54d03cbee48fe4ab20831fff0633b900bd80f"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: workflow/envs/biopython.yaml
#   prefix: /conda-envs/c47b81518865e47530ef745664745f96
#   ---
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - python=3.8.8
#     - pip:
#       - biopython==1.80
RUN mkdir -p /conda-envs/c47b81518865e47530ef745664745f96
COPY workflow/envs/biopython.yaml /conda-envs/c47b81518865e47530ef745664745f96/environment.yaml

# Conda environment:
#   source: workflow/envs/fastTree.yaml
#   prefix: /conda-envs/d6fa4873e67c5665168920a79ace66b0
#   ---
#   channels:
#     - conda-forge
#   dependencies:
#     - python=3.8.8
#     - fasttree=2.1.11
RUN mkdir -p /conda-envs/d6fa4873e67c5665168920a79ace66b0
COPY workflow/envs/fastTree.yaml /conda-envs/d6fa4873e67c5665168920a79ace66b0/environment.yaml

# Conda environment:
#   source: workflow/envs/numpy.yaml
#   prefix: /conda-envs/1401fdc4ccd2009bfe4c06cf8c12b238
#   ---
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - python=3.8.8
#     - pip:
#       - numpy==1.24.1
RUN mkdir -p /conda-envs/1401fdc4ccd2009bfe4c06cf8c12b238
COPY workflow/envs/numpy.yaml /conda-envs/1401fdc4ccd2009bfe4c06cf8c12b238/environment.yaml

# Conda environment:
#   source: workflow/envs/phylo.yaml
#   prefix: /conda-envs/2c1973abc97183164dc029c764d3b6b8
#   ---
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - python=3.8.8
#     - pip:
#       - biopython==1.80
#       - pandas==1.5.2
RUN mkdir -p /conda-envs/2c1973abc97183164dc029c764d3b6b8
COPY workflow/envs/phylo.yaml /conda-envs/2c1973abc97183164dc029c764d3b6b8/environment.yaml

# Conda environment:
#   source: workflow/envs/rf.yaml
#   prefix: /conda-envs/9c2a9dc4b1a3f8f6baabc47029f1ab7a
#   ---
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - python=3.8.8
#     - pip:
#       - robinson-foulds==1.1
RUN mkdir -p /conda-envs/9c2a9dc4b1a3f8f6baabc47029f1ab7a
COPY workflow/envs/rf.yaml /conda-envs/9c2a9dc4b1a3f8f6baabc47029f1ab7a/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/c47b81518865e47530ef745664745f96 --file /conda-envs/c47b81518865e47530ef745664745f96/environment.yaml && \
    mamba env create --prefix /conda-envs/d6fa4873e67c5665168920a79ace66b0 --file /conda-envs/d6fa4873e67c5665168920a79ace66b0/environment.yaml && \
    mamba env create --prefix /conda-envs/1401fdc4ccd2009bfe4c06cf8c12b238 --file /conda-envs/1401fdc4ccd2009bfe4c06cf8c12b238/environment.yaml && \
    mamba env create --prefix /conda-envs/2c1973abc97183164dc029c764d3b6b8 --file /conda-envs/2c1973abc97183164dc029c764d3b6b8/environment.yaml && \
    mamba env create --prefix /conda-envs/9c2a9dc4b1a3f8f6baabc47029f1ab7a --file /conda-envs/9c2a9dc4b1a3f8f6baabc47029f1ab7a/environment.yaml && \
    mamba clean --all -y
