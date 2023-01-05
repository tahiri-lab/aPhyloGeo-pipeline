import os 

def runFastTree(inputfile, outputfile, data_type):
    if data_type.lower() != "aa":
        os.system("FastTree -gtr -nt " + inputfile + " > " + outputfile)
    else:
        os.system("FastTree " + inputfile + " > " + outputfile)


if __name__ == '__main__':
    runFastTree(snakemake.input[0], snakemake.output[0], snakemake.params.data_type)