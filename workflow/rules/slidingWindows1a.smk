rule sliding_windows:
    output: 
        windows = "results/windows/window_position_{position}.fa"
    params: 
        alignment_output = config['params']['seq_file']
    conda: "../envs/biopython.yaml"
    log: "logs/sliding_windows/{position}.log"
    script: "../scripts/slidingWindows.py" 
