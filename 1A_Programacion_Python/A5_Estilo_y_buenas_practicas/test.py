from pathlib import Path, WindowsPath
import pandas as pd
import os



def check_path(your_path: str):
    """
    Function that checks if a given windows path exists or not 
    
    Parameters:
    -----------
    windows_path: str
        Any Windows path 
        
    Returns:
    -------
    pathlib.WindowsPath
        Standardized path without backslashes and tested to exist
            
    """
    your_path = your_path.encode('unicode_escape').decode()
    #converted_path= windows_path.replace('\\', '/')
    std_path=Path(your_path)
    if std_path.exists():
        print("path exists")
        return std_path 
    else:
        print("Path doesn't exist")
        raise ValueError('The path is not valid')

def read_parquet_files(folder_path: str)-> pd.DataFrame:
    std_path=check_path(folder_path)
    df_list = []
    try:
        for file in os.listdir(std_path):            
            if file.endswith('.parquet'):
                df=pd.read_parquet(f'{std_path}/{file}')
                df_list.append(df)
            total_df = pd.concat(df_list, ignore_index=True)
        return total_df
    except Exception as e:
        print(f'Error during parquet reading: {e}')
        
    
df=read_parquet_files('C:\python_directory\raw_data')
print(df.head())

