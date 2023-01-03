from csv import writer
import pandas as pd
import os


def addToCsv(window_pos, ref_feature, normalized_RF,output_csv):
    list = [window_pos, ref_feature,normalized_RF]
    with open(output_csv, 'a') as f_object:
        writer_object = writer(f_object)
        writer_object.writerow(list)
        f_object.close()


def filter_RF(rf_outfile,output_csv,rf_threshold=100):
    columns_name = ["window_pos", "ref_feature","normalized_RF"]
    with open(output_csv, 'w') as f_object:
        writer_object = writer(f_object)
        writer_object.writerow(columns_name)
        f_object.close()
    for the_file in rf_outfile:
        if os.stat(the_file).st_size != 0: 
            with open(the_file, 'r') as file:
                normalized_rf = file.read().rstrip()
            if float(normalized_rf)*100 <= float(rf_threshold):
                window_pos, ref_feature, = the_file[11:-7].split(".")
            
                normalized_RF = round(float(normalized_rf)*100,2)
                addToCsv(window_pos, ref_feature, normalized_RF,output_csv)


        

if __name__ == '__main__':
    filter_RF(snakemake.input,snakemake.output[0],snakemake.config['Thresholds']['rf_threshold'])