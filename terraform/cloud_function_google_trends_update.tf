resource "google_storage_bucket_object" "function_zip_google_trends_update" {
  name   = "google_trends_update_function.zip"
  bucket = google_storage_bucket.data_bucket.name
  source = "${path.module}/../cloud_functions/google_trends_update_table/function.zip"
}

resource "google_cloudfunctions_function" "google_trends_update" {
  name        = "google-trends-update"
  runtime     = "python310"
  entry_point = "main"
  source_archive_bucket = google_storage_bucket.data_bucket.name
  source_archive_object = google_storage_bucket_object.function_zip_google_trends_update.name
  trigger_http          = true
  available_memory_mb   = 256
  timeout               = 60
  region                = var.region
  project               = var.project_id

  environment_variables = {
    PROJECT_ID = var.project_id
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker_google_trends_update" {
  project        = google_cloudfunctions_function.google_trends_update.project
  region         = google_cloudfunctions_function.google_trends_update.region
  cloud_function = google_cloudfunctions_function.google_trends_update.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}
