terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.23.2"
    }
  }

#   version = ">= 0.15.0"
}

provider "ibm" {
  # Configuration options
  ibmcloud_api_key=var.ibm_cloud_api
  region=var.region
}