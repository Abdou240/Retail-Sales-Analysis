
---

# Retail Sales Analysis – Data Engineering Pipeline

This project implements an end-to-end data engineering pipeline for retail sales analysis using modern tools like Google Cloud Storage, BigQuery, Dataproc, Terraform, DLT, dbt, Airflow, and Power BI. The first step involves provisioning the Google Cloud infrastructure using Terraform.

## Overview

The pipeline’s infrastructure comprises:

- **Google Cloud Storage Bucket:** For storing raw and processed sales data, with lifecycle rules to manage retention and aborted uploads.
- **BigQuery Datasets:** Two separate datasets:
  - One for raw/cleaned data (`sales_cleaned_raw`)
  - One for transformed data (`sales_marts`)
- **Dataproc Cluster:** A single-node cluster (with auto-deletion) configured for data cleaning and preprocessing.
- **IAM Role Assignments:** A dedicated service account, whose email is dynamically extracted from the provided credentials file, is used for deploying and managing resources. The service account is granted minimal—but sufficient—permissions to perform the following operations:
  - **Dataproc Management:** `roles/dataproc.editor`
  - **Storage Management:** `roles/storage.admin` and `roles/storage.objectAdmin`  
    *(The `roles/storage.objectAdmin` role is essential for allowing the service account to read and update objects in custom staging and temporary buckets used by Dataproc.)*
  - **BigQuery Management:** `roles/bigquery.dataEditor`
  - **Compute Management:** `roles/compute.instanceAdmin`
  - **IAM Policy Management:** `roles/iam.securityAdmin` and `roles/iam.serviceAccountUser`

## Step 1: Provision Infrastructure with Terraform

Terraform is used to set up the following key components on Google Cloud:

1. **Provider and Service Account Email Extraction:**
   - The configuration reads your service account credentials from a JSON file.
   - It dynamically extracts the `client_email` (used as the service account) so you do not have to hardcode this value.

2. **Resource Provisioning:**
   - **Cloud Storage Bucket:** A bucket is created for staging sales data along with lifecycle rules (delete objects older than 7 days and abort incomplete multipart uploads after 1 day).
   - **BigQuery Datasets:** Two datasets are provisioned for storing raw (cleaned) and transformed data.
   - **Dataproc Cluster:** A single-node cluster is created to perform data cleaning. The configuration specifies custom staging and temporary buckets so that the service account (with the appropriate storage roles) can access them. An auto-deletion TTL is configured to avoid unnecessary costs.
  
3. **IAM Role Assignments:**
   - A dedicated module assigns all the necessary IAM roles to the service account. In addition to roles for managing Dataproc, BigQuery, Compute, and Storage, the service account is granted the `roles/storage.objectAdmin` role. This role is required to grant the service account permissions on custom staging and temporary buckets that Dataproc uses for task execution and file storage.

## Getting Started

1. **Configure Your Environment:**
   - Place your credentials file (e.g., `keys/my-creds.json`) in the appropriate directory.
   - Edit the `terraform/variables.tf` file if needed to adjust defaults, such as project ID, region, or resource names.

2. **Initialize and Apply Terraform:**
   - Navigate to the Terraform directory and run:
     ```bash
     terraform init
     terraform plan
     terraform apply
     ```
   - Terraform will then deploy your GCP infrastructure (storage, datasets, cluster, and IAM role assignments) accordingly.
 
---
