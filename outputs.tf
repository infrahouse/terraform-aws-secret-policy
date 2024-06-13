output "policy_json" {
  description = "JSON document with a admin/writer/reader secret policy."
  value = data.aws_iam_policy_document.permission-policy.json
}
