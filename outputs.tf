output "kms_key_id" {
  description = "The ID of the KMS key."
  value       = aws_kms_key.key.id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key."
  value       = aws_kms_key.key.arn
}

output "kms_key_alias_arn" {
  description = "The ARN of the KMS key alias."
  value       = aws_kms_alias.this.arn
}

output "kms_key_alias_name" {
  description = "The name of the KMS key alias."
  value       = aws_kms_alias.this.name
}

output "kms_key_policy" {
  description = "The policy JSON document attached to the KMS key."
  value       = data.aws_iam_policy_document.kms_policy.json
}