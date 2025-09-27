import dlt
import pandas as pd

STUDENT_NAME = "ez"

@dlt.resource(name=f"covid19_{STUDENT_NAME}")
def get_sales_data():
    """
    """
    file_path = "/var/dlt/datasets/covid19_data.csv"
    df = pd.read_csv(file_path)
    yield df.to_dict(orient="records")

if __name__ == "__main__":
    print("Running covid19 data pipeline...")
    
    pipeline = dlt.pipeline(
        pipeline_name="covid19_cases_data_v4",
        destination="clickhouse",
        dataset_name="raw" 
    )

    load_info = pipeline.run(get_sales_data())
    print(load_info)
    print("Covid 19 data pipeline finished successfully!")