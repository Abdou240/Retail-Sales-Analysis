terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.28.0"
    }
  }
}

provider "google" {
  credentials = file("keys/my-creds.json")
  project     = "vigilant-cider-376613"
  region      = "europe-west4"
}

resource "google_storage_bucket" "raw_bucket" {
  name          = "sales_raw"
  location      = "EU"
  force_destroy = true
  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
resource "google_storage_bucket" "cleaned_bucket" {
  name          = "sales_cleaned"
  location      = "EU"
  force_destroy = true
  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}


resource "google_bigquery_dataset" "demo-dataset" {
  dataset_id = "demo_dataset"
}
