
from Bio import SeqIO


def getWindowsFiltered(alignment_output, window_pos, outfile_name):
    for seq_record in SeqIO.parse(alignment_output, "fasta"):
        start, end = window_pos.split('_')
        records = seq_record[int(start):int(end)]
        with open(outfile_name, "a") as handle:
            SeqIO.write(records, handle, "fasta") 

if __name__ == '__main__':
    getWindowsFiltered(snakemake.params.alignment_output, snakemake.wildcards.windows_pos, snakemake.output.windows_filtered)