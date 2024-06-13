# terraform-aws-secret-policy
The module prepares a JSON with policy for a `aws_secretsmanager_secret_policy` resource.
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.permission-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.caller_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admins"></a> [admins](#input\_admins) | List of role ARNs that will have all permissions of the secret. | `list(string)` | `null` | no |
| <a name="input_readers"></a> [readers](#input\_readers) | List of role ARNs that will have read permissions of the secret. | `list(string)` | `null` | no |
| <a name="input_writers"></a> [writers](#input\_writers) | List of role ARNs that will have write permissions of the secret. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_json"></a> [policy\_json](#output\_policy\_json) | JSON document with a admin/writer/reader secret policy. |
