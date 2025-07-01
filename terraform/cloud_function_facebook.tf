resource "google_storage_bucket_object" "function_zip_facebook_ads" {
  name   = "facebook_ads_function_v3.zip"  # <- novo nome
  bucket = google_storage_bucket.data_bucket.name
  source = "${path.module}/../cloud_functions/facebook_ads/function.zip"
}



resource "google_cloudfunctions_function" "facebook_ads" {
  name        = "fetchFacebookAds"
  description = "Função para coletar dados da Facebook Ads Library"
  runtime     = "python310"
  available_memory_mb = 256
  timeout     = 60

  source_archive_bucket = google_storage_bucket.data_bucket.name
source_archive_object = google_storage_bucket_object.function_zip_facebook_ads.name

  trigger_http = true
  region = var.region

  environment_variables = {
    FB_ADS_TOKEN  = var.fb_ads_token
    SEARCH_TERM   = var.search_term
    BUCKET_NAME   = google_storage_bucket.data_bucket.name
  }
}

output "function_url" {
  value = google_cloudfunctions_function.facebook_ads.https_trigger_url
}
