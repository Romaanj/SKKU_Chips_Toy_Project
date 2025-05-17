import os
import re
from pathlib import Path
import csv
import pandas as pd

def is_Weight_File(filename: str):
    regex = re.compile('weight')
    return regex.search(filename)

def is_Bias_File(filename: str):
    regex = re.compile('bias')
    return regex.search(filename)

def is_Slope_File(filename: str):
    regex = re.compile('alpha')
    return regex.search(filename)

# ------------------------------------------------------------------------------------------------------------------------

def Weight_From_CSV_To_TXT(csv_dir: str, csv_file_name: str, save_dir="result"):
    p = re.compile('[a-z0123]+')
    matched = p.findall(csv_file_name)

    if(matched[1] == 'last'):
        layer_name = matched[0] + "_" + matched[1]
        param_type = matched[2]
    elif (matched[1] == 'mapping'):
        layer_name = matched[0] + "_" + matched[1] + "." + matched[2]
        param_type = matched[3]
    else:
        layer_name = matched[0] + "_" + matched[1]
        param_type = matched[3]

    output_file_type = "txt"

    csv_file_path = Path(csv_dir) / csv_file_name
    df = pd.read_csv(csv_file_path, header=None)

    output_dir = Path(save_dir) / layer_name
    output_dir.mkdir(parents=True, exist_ok=True)
    for idx, row in enumerate(df.itertuples(index=False)):
        output_file_path = output_dir / f"{layer_name}_{param_type}_{idx}.{output_file_type}"

        hex_lines = "\n".join([f"{int(val) & 0xFF:02X}" for val in row])

        with output_file_path.open("w", encoding="utf-8") as f:
            f.write(hex_lines)

        print(f"{output_file_path.name} 저장 완료 ")

# ------------------------------------------------------------------------------------------------------------------------

def Read_CSV_ColumnWise_and_Strip(csv_file_path: str):
    # declare list of lists, each element is one whole column in CSV file
    columns = []

    with csv_file_path.open("r", encoding="utf-8") as f:
        reader = csv.reader(f)
        for row in reader:
            for i, val in enumerate(row):
                val = val.strip()
                if len(columns) <= i:
                    columns.append([])
                if val:
                    columns[i].append(f"{int(val) & 0xFF:02X}") # save each values as two digit hexadecimal

    return columns

def Bias_From_CSV_To_TXT(csv_dir: str, csv_file_name: str, save_dir="result"):
    p = re.compile('[a-z0123]+')
    matched = p.findall(csv_file_name)

    if(matched[1] == 'last'):
        layer_name = matched[0] + "_" + matched[1]
        param_type = matched[2]
    elif (matched[1] == 'mapping'):
        layer_name = matched[0] + "_" + matched[1] + "." + matched[2]
        param_type = matched[3]
    else:
        layer_name = matched[0] + "_" + matched[1]
        param_type = matched[3]

    output_file_type = "txt"

    # read CSV and parsing
    csv_file_path = Path(csv_dir) / csv_file_name
    columns = Read_CSV_ColumnWise_and_Strip(csv_file_path)

    # save each column into seperated files
    output_dir = Path(save_dir) / layer_name
    output_dir.mkdir(parents=True, exist_ok=True)

    for i, hex_list in enumerate(columns):
        output_file_path = output_dir / f"{layer_name}_{param_type}_{i}.{output_file_type}"

        with output_file_path.open("w", encoding="utf-8") as f_out:
            f_out.write("\n".join(hex_list))

        print(f"{output_file_path.name} 저장 완료")

def Slope_From_CSV_To_TXT(csv_dir: str, csv_file_name: str, save_dir="result"):
    p = re.compile('[a-z14]+')
    matched = p.findall(csv_file_name)

    if (matched[1] == 'mapping'):
        layer_name = matched[0] + "_" + matched[1] + "." + matched[2]
    else:
        layer_name = matched[0] + "_" + matched[1]

    param_type = "slope"
    output_file_type = "txt"

    # read CSV and parsing
    csv_file_path = Path(csv_dir) / csv_file_name
    columns = Read_CSV_ColumnWise_and_Strip(csv_file_path)

    # save each column into seperated files
    output_dir = Path(save_dir) / layer_name
    output_dir.mkdir(parents=True, exist_ok=True)

    for i, hex_list in enumerate(columns):
        output_file_path = output_dir / f"{layer_name}_{param_type}_{i}.{output_file_type}"

        with output_file_path.open("w", encoding="utf-8") as f_out:
            f_out.write("\n".join(hex_list))

        print(f"{output_file_path.name} 저장 완료")

# ------------------------------------------------------------------------------------------------------------------------

def Extract_Bias_From_CSV(int8_params_path: str):
    for filename in os.listdir(int8_params_path):
        if filename.endswith(".csv"):
            if is_Bias_File(filename):
                Bias_From_CSV_To_TXT(int8_params_path, filename)

def Extract_Slope_From_CSV(int8_params_path: str):
    for filename in os.listdir(int8_params_path):
        if filename.endswith(".csv"):
            if is_Slope_File(filename):
                Slope_From_CSV_To_TXT(int8_params_path, filename)

def Extract_Weight_From_CSV(int8_params_path: str):
    for filename in os.listdir(int8_params_path):
        if filename.endswith(".csv"):
            if is_Weight_File(filename):
                Weight_From_CSV_To_TXT(int8_params_path, filename)

# ------------------------------------------------------------------------------------------------------------------------

def Extract_Params_From_CSV(int8_params_path: str):
    Extract_Weight_From_CSV(int8_params_path)
    Extract_Bias_From_CSV(int8_params_path)
    Extract_Slope_From_CSV(int8_params_path)

# ------------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    int8_params_path = r"C:\Users\송성민\Desktop\SKKU_CHIPS\int8_params_scale_fixed_retraining"
    Extract_Params_From_CSV(int8_params_path)
