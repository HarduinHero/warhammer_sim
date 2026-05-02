import pandas as pd
import requests
import sqlite3

CSV_SEP = "|"

BASE_URL = "http://wahapedia.ru/wh40k10ed/"

TABLES = [
    "Factions",
    "Source",
    "Abilities",
    "Detachments",
    "Stratagems",
    "Enhancements",
    "Detachment_abilities",
    "Datasheets",
    "Datasheets_abilities",
    "Datasheets_keywords",
    "Datasheets_models",
    "Datasheets_options",
    "Datasheets_wargear",
    "Datasheets_unit_composition",
    "Datasheets_models_cost",
    "Datasheets_stratagems",
    "Datasheets_enhancements",
    "Datasheets_detachment_abilities",
    "Datasheets_leader"
]

def get_table_csv_url(table_name:str) -> str :
    return f"{BASE_URL}{table_name}.csv"

def load_csv(csv_url:str) -> pd.DataFrame :
    response = requests.get(csv_url)
    parsed_data = list(map(lambda x: x.split('|'), response.content.decode("utf-8-sig").strip("\r\n").split("\r\n")))
    cols = parsed_data[0]
    data = parsed_data[1::]
    output_df = pd.DataFrame(data, columns=cols)
    output_df.drop(columns=[''], inplace=True)
    return output_df

def insert_dataframe(conn:sqlite3.Connection, data:pd.DataFrame, table:str) -> None :
    cols = list(data.columns)
    sql = f"INSERT INTO {table} ({', '.join(cols)}) VALUES({', '.join(['?' for _ in range(len(cols))])});"
    conn.executemany(sql, [row[1].to_list() for row in data.iterrows()])

def main() -> None :
    DB_FILENAME = "wahapedia_loaded_data.sqlite3"
    INIT_SCRIPT_FILENAME = "init.sql"

    with sqlite3.connect(DB_FILENAME, autocommit=True) as conn :

        with open(INIT_SCRIPT_FILENAME, "r") as init_script_fd :
            conn.executescript(init_script_fd.read())

        for table_name in TABLES :
            print(f"{table_name}...", sep="", end="")
            table_data_df = load_csv(get_table_csv_url(table_name))
            insert_dataframe(conn, table_data_df, table_name)
            print("OK")

if __name__ == "__main__" :
    main()