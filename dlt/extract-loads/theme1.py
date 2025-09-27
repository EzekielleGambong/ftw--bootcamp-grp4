import os
import dlt
import psycopg2
from psycopg2.extras import RealDictCursor

# --- Connection Details ---
def get_connection():
    # these will KeyError if the env var isn't set
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

# --- Define dlt resources for each table we need ---

@dlt.resource(write_disposition="replace", name="customer")
def get_customers():
    """Extract all customers from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM customer;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

@dlt.resource(write_disposition="replace", name="invoice")
def get_invoices():
    """Extract all invoices from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM invoice;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

@dlt.resource(write_disposition="replace", name="invoice_line")
def get_invoice_lines():
    """Extract all invoice lines from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM invoice_line;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

# --- Main function to run the pipeline ---
def run():
    pipeline = dlt.pipeline(
        pipeline_name="chinook_customer_loyalty",
        destination="clickhouse",
        dataset_name="chinook_raw" # We'll load into a 'chinook_raw' schema
    )
    
    print("Fetching and loading customer, invoice, and invoice_line tables...")
    # Run the pipeline with all three resources
    load_info = pipeline.run([get_customers(), get_invoices(), get_invoice_lines()])
    
    print("Loading finished!")
    print(load_info)

if __name__ == "__main__":
    run()