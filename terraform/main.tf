
resource "google_storage_bucket" "data_bucket" {
  name     = "${var.project_id}-data-thiago"
  location = var.region
}

resource "google_bigquery_table" "facebook_ads" {
  dataset_id = "raw"
  table_id   = "facebook_ads"
  deletion_protection = false

  external_data_configuration {
    autodetect = true
    source_format = "NEWLINE_DELIMITED_JSON"
    

    source_uris = [
      "gs://${google_storage_bucket.data_bucket.name}/facebook_ads/*.json"
    ]
  }
}

resource "google_bigquery_dataset" "raw" {
  dataset_id = "raw"
  location   = var.region  # ← isso já deve estar como "southamerica-east1"
}

resource "google_bigquery_dataset" "silver" {
  dataset_id = "silver"
  location   = var.region
}

resource "google_bigquery_dataset" "gold" {
  dataset_id = "gold"
  location   = var.region
}



