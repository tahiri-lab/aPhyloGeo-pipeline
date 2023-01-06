

rule sliding_windows:
    output: 
        windows = "results/windows/window_position_{position}.fa"
    params: 
        alignment_output = config['params']['seq_file']
    conda:
        "../env/biopython.yaml"
    script: "../scripts/slidingWindows.py" 