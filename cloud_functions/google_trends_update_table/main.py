import os
from google.cloud import bigquery

def main(request):
    project_id = os.environ.get("PROJECT_ID", "adtrends-insight")
    dataset_id = "raw"
    table_id = "google_trends"

    client = bigquery.Client(project=project_id)

    table_ref = f"{project_id}.{dataset_id}.{table_id}"

    uri = "gs://adtrends-insight-data-thiago/google_trends/*.csv"

    external_config = bigquery.ExternalConfig("CSV")
    external_config.autodetect = True
    external_config.source_uris = [uri]

    table = bigquery.Table(table_ref)
    table.external_data_configuration = external_config

    table = client.create_table(table, exists_ok=True)
    return f"Table {table_id} updated with URI: {uri}"
