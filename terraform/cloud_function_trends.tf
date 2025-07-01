resource "google_storage_bucket_object" "trends_function_zip" {
  name   = "google_trends_function_v2.zip"
  bucket = google_storage_bucket.data_bucket.name
  source = "../cloud_functions/google_trends/function_v2.zip"
}

resource "google_cloudfunctions_function" "google_trends" {
  name        = "fetchGoogleTrends"
  entry_point = "main"
  runtime     = "python310"
  region      = var.region

  source_archive_bucket = google_storage_bucket.data_bucket.name
  source_archive_object = google_storage_bucket_object.trends_function_zip.name

  trigger_http = true
  available_memory_mb = 256
  timeout = 60

  environment_variables = {
    SEARCH_TERM = var.search_term
    BUCKET_NAME = google_storage_bucket.data_bucket.name
  }
}

output "trends_function_url" {
  value = google_cloudfunctions_function.google_trends.https_trigger_url
}
