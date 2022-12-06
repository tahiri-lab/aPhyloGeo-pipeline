#configfile: 'config/config.yaml'


rule slidingWindows:
    input: local(config['params']['seq_file'])
    output: "results/slidingWindows.done"
    script:
        "../scripts/slidingWindows.py"