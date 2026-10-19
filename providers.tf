# AWS Provider Configuration
# Region: Asia Pacific (Sydney)

provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      Project     = "cloud-native-platform-aws"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}
