##################################################################################
# Backend Configuration
# Use S3 remote backend
# Init : terraform init -backend-config=./config/shared/backend-shared.conf
##################################################################################
terraform {
  backend "s3" {
  }
}