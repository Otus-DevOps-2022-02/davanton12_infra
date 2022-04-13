terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "stage-terraform-state"
    key        = "state/terraform.tfstate"
    region     = "us-east-1"
    access_key = "YC"
    secret_key = "YC"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
