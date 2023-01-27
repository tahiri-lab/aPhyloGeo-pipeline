checkpoint rf_phyML: 
   input: expand("results/rf/{position}.{feature}.rf_ete", position = POS, feature=feature_names)
   output: "results/rf_phyML.csv"
   conda: "../envs/python.yaml"
   log: "logs/rf_phyML/thelog"
   script: "../scripts/rfAfterPhyML.py"