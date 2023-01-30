import numpy as np
import re


def calculateAverageBootstrapRax(outtree):
    f = open(outtree, "r").read()
    numbers = re.findall(r'[)][:]\d+[.]\d+', f)
    values = [float(x[2:]) for x in numbers]
    return np.mean(values)

def filterBootstrap(raxmlTree,Bootstrap_file, bootstrap_threshold=0):
    bootstrap = calculateAverageBootstrapRax(raxmlTree)
    if bootstrap >= float(bootstrap_threshold):
        with open(Bootstrap_file,'w') as f:
            f.write(str(bootstrap))
    else:
        open(Bootstrap_file, 'w').close()


if __name__ == '__main__':
    filterBootstrap(
        snakemake.input[0], 
        snakemake.output[0], 
        snakemake.config['thresholds']['bootstrap_threshold']
    )
