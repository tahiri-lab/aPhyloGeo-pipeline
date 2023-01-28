from Bio import AlignIO
from Bio import Phylo
from Bio.Phylo.TreeConstruction import DistanceCalculator
from Bio.Phylo.TreeConstruction import DistanceTreeConstructor
from Bio.Phylo.Consensus import *
import re
import statistics


def bootstrapFilter(file_window, file_consensus, data_type, bootstrap_threshold=0):
    # get bootstrap consensus tree
    msa = AlignIO.read(file_window, 'fasta')
    if data_type.lower() != "aa":
        calculator = DistanceCalculator('identity')
    else:
        calculator = DistanceCalculator('blosum62')
    constructor = DistanceTreeConstructor(calculator)
    consensus_tree = bootstrap_consensus(msa, 100, constructor, majority_consensus)

    # get the average of confidence value
    numbers = re.findall(r'(?=(confidence=)(\d+))', format(consensus_tree))
    confidence = [float(x[1]) for x in numbers]
    bootstrap = statistics.mean(confidence)

    # filter
    if bootstrap >= float(bootstrap_threshold):
        Phylo.write(consensus_tree, file_consensus, "newick")
    else:
        open(file_consensus, 'w').close()


if __name__ == '__main__':
    bootstrapFilter(snakemake.input[0], snakemake.output[0], snakemake.params.data_type,
                    snakemake.config['thresholds']['bootstrap_threshold'])
