terraform {
  required_version = "~> 1.0.3"

}

provider "aws" {
  region = var.region
}
