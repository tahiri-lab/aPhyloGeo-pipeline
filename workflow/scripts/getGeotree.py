import pandas as pd
from Bio import Phylo
from Bio.Phylo.TreeConstruction import DistanceTreeConstructor
from Bio.Phylo.TreeConstruction import _DistanceMatrix
import re

def getGeoTree(df, column_with_specimen_name, column_to_search, outfile_name):
    
    # creation d'une liste contenant les noms des specimens et les temperatures min
    meteo_data = df[column_to_search].tolist()
    nom_var = df[column_with_specimen_name].tolist()
    nbr_seq = len(nom_var)
    # ces deux valeurs seront utiles pour la normalisation
    max_value = 0
    min_value = 0

    # premiere boucle qui permet de calculer une matrice pour chaque sequence
    temp_tab = []
    for e in range(nbr_seq):
        # une liste qui va contenir toutes les distances avant normalisation
        temp_list = []
        for i in range(nbr_seq):
            maximum = max(float(meteo_data[e]), float(meteo_data[i]))
            minimum = min(float(meteo_data[e]), float(meteo_data[i]))
            distance = maximum - minimum
            temp_list.append(float("{:.6f}".format(distance)))

        # permet de trouver la valeur maximale et minimale pour la donnee meteo et ensuite d'ajouter la liste temporaire a un tableau
        if max_value < max(temp_list):
            max_value = max(temp_list)
        if min_value > min(temp_list):
            min_value = min(temp_list)
        temp_tab.append(temp_list)
    #print('column_to_search: ',column_to_search)
    #print('max_value: ',max_value)
    #print('min_value',min_value)
    #print("temp_tab:",temp_tab)

    # calculate des matrices normalisees 
    tab_df = pd.DataFrame(temp_tab)
    dm_df = (tab_df - min_value)/(max_value - min_value)
    dm_df = dm_df.round(6)

    matrix =[dm_df.iloc[i,:i+1].tolist() for i in range(len(dm_df))]

    dm = _DistanceMatrix(nom_var, matrix)
    constructor = DistanceTreeConstructor()
    tree = constructor.nj(dm)
    Phylo.write(tree, outfile_name, "newick")
    #with open(outfile_name, 'wb') as outfile:
    #    outfile.write(tree.write(format=5)) 
    with open(outfile_name, 'r') as f:
        text = f.read()
        text = re.sub(r'Inner\d+', '', text)
    with open(outfile_name, 'w') as file:
        file.write(text)


if __name__ == '__main__':
    getGeoTree(snakemake.params.df_geo, snakemake.config['params']['specimen_id'], snakemake.wildcards.feature, snakemake.output.newick)