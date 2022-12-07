from Bio import AlignIO
from Bio import Phylo
from Bio.Phylo.TreeConstruction import DistanceCalculator
from Bio.Phylo.TreeConstruction import DistanceTreeConstructor
from Bio.Phylo.Consensus import *
import re
import statistics

def bootstrapFilter(file_window,file_consensus,bootstrap_threshold=0):
    # get bootstrap consensus tree
    msa = AlignIO.read(file_window, 'fasta')
    calculator = DistanceCalculator('identity')
    constructor = DistanceTreeConstructor(calculator)
    consensus_tree = bootstrap_consensus(msa, 100, constructor, majority_consensus)

    #get the average of confidence value
    numbers = re.findall(r'(?=(confidence=)(\d+))', format(consensus_tree))
    confidence = [float(x[1]) for x in numbers]
    bootstrap = statistics.mean(confidence)

    #filter
    if bootstrap >= float(bootstrap_threshold):
        Phylo.write(consensus_tree, file_consensus, "newick")
    else:
        open(file_consensus, 'w').close()


if __name__ == '__main__':
    bootstrapFilter(snakemake.input[0], snakemake.output[0],snakemake.config['Thresholds']['bootstrap_threshold'])