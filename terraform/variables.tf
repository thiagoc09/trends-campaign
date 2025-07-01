variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  default     = "southamerica-east1"
}
variable "fb_ads_token" {
  description = "Token da API do Facebook Ads Library"
  type        = string
}

variable "search_term" {
  description = "Termo a ser buscado na Ads Library"
  type        = string
}

