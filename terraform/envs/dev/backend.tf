terraform {
  backend "s3" {
    bucket         = "visitor-terraform-state"         # Replace with your actual bucket
    key            = "eks/dev/terraform.tfstate"        # Unique per environment
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
