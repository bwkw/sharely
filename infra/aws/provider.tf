provider "aws" {
  profile     = "sharely"
  region      = "ap-northeast-1"
  max_retries = 20
  default_tags {
    tags = {
      Environment = "stg"
      Service     = "sharely"
    }
  }
}
