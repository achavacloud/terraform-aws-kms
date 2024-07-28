variable "description" {
  description = "Description of the KMS key."
  type        = string
  default     = "Managed by Terraform"
}

variable "deletion_window_in_days" {
  description = "Number of days before the key is deleted after being scheduled for deletion."
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled."
  type        = bool
  default     = false
}

variable "key_usage" {
  description = "Specifies the intended use of the key. Defaults to ENCRYPT_DECRYPT."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  description = "Specifies the type of KMS key to create. The default value is SYMMETRIC_DEFAULT."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "multi_region" {
  description = "Specifies whether the KMS key is a multi-Region (true) or regional (false) key."
  type        = bool
  default     = false
}

variable "alias_name" {
  description = "The alias name for the KMS key."
  type        = string
  default     = "example-key-alias"
}

variable "policy" {
  description = "The key policy JSON. If not provided, a default policy will be generated."
  type        = string
  default     = ""
}

variable "region" {
  description = "The AWS region for the KMS key."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "dynamic_statements" {
  description = "List of additional policy statements to include in the KMS policy."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = []
}