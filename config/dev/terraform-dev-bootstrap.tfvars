#########################################
# Credentials and region
#########################################

aws_region                        = "us-east-1"
aws_profile                       = "personal-terraform"
bucket_state_name                 = "personal-laravel-dev-tf-state"
dynamodb_table_state_locking_name = "personal-laravel-dev-tf-state-lock"

tags = {
  Environment = "dev",
  ManagedBy   = "terraform",
}
