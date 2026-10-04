terraform {
  backend "s3" {
    bucket = "w7-vpc-key-ec2-volume-terraform"
    key    = "week10/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = false
 }
}