

rule slidingWindows:
    input: local(config['params']['seq_file'])
    output: touch("results/slidingWindows.done")
    script:
        "../scripts/slidingWindows.py"