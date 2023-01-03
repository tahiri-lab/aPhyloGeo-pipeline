

rule sliding_windows:
    output: 
        windows = "results/windows/window_position_{position}.fa"
    params: 
        alignment_output = config['params']['seq_file']
    script: "../scripts/slidingWindows.py" 