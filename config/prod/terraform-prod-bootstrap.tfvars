#########################################
# Credentials and region
#########################################

aws_region                        = "us-east-1"
aws_profile                       = "personal-terraform"
bucket_state_name                 = "personal-prod-tf-state"
dynamodb_table_state_locking_name = "personal-prod-tf-state-lock"

tags = {
  Environment = "prod",
  ManagedBy   = "terraform",
}
