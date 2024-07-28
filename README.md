## Terraform AWS KMS Key Module

This Terraform module creates and manages an AWS KMS (Key Management Service) key along with an alias and IAM policies. The module supports dynamic configuration, allowing for the customization of the key and its policies.

Features
- KMS Key: Creates a KMS key for encryption and decryption.
- IAM Policies: Dynamically generates IAM policies for access control.
- Key Alias: Sets a user-friendly alias for the KMS key.
- Key Rotation: Supports automatic key rotation.
- Tags: Allows tagging of resources for easy management and tracking.

```sh
terraform-aws-kms/
├── main.tf          # Core resource definitions
├── variables.tf     # Input variable definitions
├── outputs.tf       # Output definitions
└── team_name.tf # (Optional) consists of kms key config through locals 
```

**main.tf**
```hcl
provider "aws" {
region = var.region
}

module "kms" {
  source   = "achavacloud/kms/aws"
  for_each = { for key, value in local.kms_keys : key => value if local.apply_kms_key1 }

  description              = each.value.description
  deletion_window_in_days  = each.value.deletion_window_in_days
  enable_key_rotation      = each.value.enable_key_rotation
  key_usage                = each.value.key_usage
  customer_master_key_spec = each.value.customer_master_key_spec
  multi_region             = each.value.multi_region
  alias_name               = each.value.alias_name
  region                   = each.value.region

  dynamic_statements = each.value.dynamic_statements

  tags = each.value.tags
}
```

**outputs.tf**
```hcl
output "vpc_id" {
value = module.vpc.vpc_id
}

output "public_subnet_ids" {
value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
value = module.vpc.private_subnet_ids
}
```

**team_name.tf**
```hcl
locals {
  apply_kms_key1 = true
  kms_keys = {
    key1 = {
      description             = "KMS key1 for team1"
      deletion_window_in_days = 2
      enable_key_rotation     = true
      key_usage               = "ENCRYPT_DECRYPT"
      customer_master_key_spec = "SYMMETRIC_DEFAULT"
      multi_region            = false
      alias_name              = "key_name"
      region                  = "us-east-1"
      dynamic_statements = [
        {
          sid       = "crossCustomer1Team"
          effect    = "Allow"
          actions   = ["kms:Encrypt", "kms:Decrypt"]
          resources = ["*"]
          principals = [
            {
              type        = "AWS"
              identifiers = ["arn:aws:iam::234567890123:role/customer1Team"]
            }
          ]
        },
        {
          sid       = "crossCustomer2Team"
          effect    = "Allow"
          actions   = ["kms:Decrypt"]
          resources = ["*"]
          principals = [
            {
              type        = "AWS"
              identifiers = ["arn:aws:iam::234567890123:role/customer2Team"]
            }
          ]
        }
      ]
      tags = {
        Environment = "env"
        Owner       = "key1"
      }
    }
  }
}
```
**variables.tf**
```hcl
variable "aws_region" {
  description = "Region to deploy the keys"
  type = string
  default = ""
}

variable "kms_keys" {
  description = "A map of KMS key configurations for each key to be created."
  type = map(object({
    description              = string
    deletion_window_in_days  = number
    enable_key_rotation      = bool
    key_usage                = string
    customer_master_key_spec = string
    multi_region             = bool
    alias_name               = string
    region                   = string
    dynamic_statements = list(object({
      sid       = string
      effect    = string
      actions   = list(string)
      resources = list(string)
      principals = list(object({
        type        = string
        identifiers = list(string)
      }))
    }))
    tags = map(string)
  }))
}
```
