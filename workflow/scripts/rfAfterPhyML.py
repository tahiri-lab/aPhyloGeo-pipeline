from csv import writer
import time
import os


def addToCsv(window_pos, ref_feature, normalized_RF,output_csv):
    list = [window_pos, ref_feature,normalized_RF]
    with open(output_csv, 'a') as f_object:
        writer_object = writer(f_object)
        writer_object.writerow(list)
        f_object.close()


def filter_RF(rf_outfile,output_csv):
    time.sleep(5)
    columns_name = ["window_pos", "ref_feature","normalized_RF"]
    if not os.path.exists(output_csv):
        with open(output_csv, 'w') as f_object:
            writer_object = writer(f_object)
            writer_object.writerow(columns_name)
            f_object.close()
    for the_file in rf_outfile:
        if os.stat(the_file).st_size == 0: 
            normalized_RF = 999
        else:
            with open(the_file, 'r') as file:
                normalized_rf = file.read().rstrip()
            normalized_RF = round(float(normalized_rf)*100,2)
        window_pos, ref_feature, = the_file.split("/")[-1].split(".")[:2]
        addToCsv(window_pos, ref_feature, normalized_RF,output_csv)

if __name__ == '__main__':
    filter_RF(snakemake.input,snakemake.output[0])