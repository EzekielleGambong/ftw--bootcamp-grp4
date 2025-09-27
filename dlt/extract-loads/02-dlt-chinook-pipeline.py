import os
import dlt
import psycopg2
from psycopg2.extras import RealDictCursor

def get_connection():
    host     = os.environ["POSTGRES_HOST"]
    port     = int(os.environ["POSTGRES_PORT"])
    user     = os.environ["POSTGRES_USER"]
    password = os.environ["POSTGRES_PASSWORD"]
    dbname   = os.environ["POSTGRES_DB"]

    return psycopg2.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        dbname=dbname
    )


TABLES_TO_EXTRACT = [
    "customer", "invoice", "invoice_line", "artist", "album", 
    "track", "media_type", "playlist", "playlist_track", "employee", "genre"
]

@dlt.source
def chinook_source():
    for table_name in TABLES_TO_EXTRACT:
        @dlt.resource(name=table_name, write_disposition="replace")
        def get_table_data(table=table_name):
            conn = get_connection()
            cur = conn.cursor(cursor_factory=RealDictCursor)
            print(f"Extracting {table}...")
            cur.execute(f"SELECT * FROM {table};")
            yield cur.fetchall()
            conn.close()
        yield get_table_data

def run():
    pipeline = dlt.pipeline(
        pipeline_name="chinook_full_pipeline_grp4",
        destination="clickhouse",
        dataset_name="chinook_raw_grp4"
    )
    
    print("Fetching and loading all Chinook tables...")
    load_info = pipeline.run(chinook_source())
    
    print("Loading finished!")
    print(load_info)

if __name__ == "__main__":
    run()