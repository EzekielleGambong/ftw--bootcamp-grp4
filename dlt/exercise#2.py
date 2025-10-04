import dlt
import pandas as pd

STUDENT_NAME = "4grp"

@dlt.resource(name=f"raw_courses_{STUDENT_NAME}")
def get_courses():
    df = pd.read_csv("/var/dlt/datasets/dataset2/courses.csv")
    yield df.to_dict(orient="records")

@dlt.resource(name=f"raw_studentAssessment_{STUDENT_NAME}")
def get_studentAssessment():
    df = pd.read_csv("/var/dlt/datasets/dataset2/studentAssessment.csv")
    yield df.to_dict(orient="records")

@dlt.resource(name=f"raw_studentInfo_{STUDENT_NAME}")
def get_student_info():
    df = pd.read_csv("/var/dlt/datasets/dataset2/studentInfo.csv")
    yield df.to_dict(orient="records")

@dlt.resource(name=f"raw_studentRegistration_{STUDENT_NAME}")
def get_studentRegistration():
    df = pd.read_csv("/var/dlt/datasets/dataset2/studentRegistration.csv")
    yield df.to_dict(orient="records")

if __name__ == "__main__":
    pipeline = dlt.pipeline(
        pipeline_name="oulad_pipeline",
        destination="clickhouse",
        dataset_name=f"{STUDENT_NAME}_raw"
    )

    load_info = pipeline.run([get_courses(), get_studentAssessment(), get_studentRegistration(), get_student_info()])
    print(load_info)
