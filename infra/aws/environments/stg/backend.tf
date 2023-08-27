terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "environments/stg/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
