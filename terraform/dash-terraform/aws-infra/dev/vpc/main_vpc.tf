# Specify the provider
provider "aws" {
  shared_credentials_file = "/c/Users/anupk/.aws/credentials"
  region                  = "${var.provider_region}"
}

module "dev_vpc" {
  source = "../../modules/vpc"
}
