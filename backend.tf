terraform {
  backend "s3" {
    bucket         = "tf-state-platform-engineering-bucket"
    key            = "eks-platform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}