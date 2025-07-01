resource "google_storage_bucket_object" "trends_function_zip" {
  name   = "google_trends_function.zip"
  bucket = google_storage_bucket.data_bucket.name
  source = "${path.module}/../cloud_functions/google_trends/function.zip"
}

resource "google_cloudfunctions_function" "google_trends" {
  name        = "fetchGoogleTrends"
  description = "Função para coletar Google Trends por termo"
  runtime     = "python310"
  available_memory_mb = 256
  timeout     = 60

  source_archive_bucket = google_storage_bucket.data_bucket.name
  source_archive_object = google_storage_bucket_object.trends_function_zip.name
  entry_point = "main"
  trigger_http = true
  region = var.region

  environment_variables = {
    SEARCH_TERM = var.search_term
    BUCKET_NAME = google_storage_bucket.data_bucket.name
  }
}

output "trends_function_url" {
  value = google_cloudfunctions_function.google_trends.https_trigger_url
}
