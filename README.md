# terraform-aws-secret-policy

Terraform module for generating IAM policy documents for AWS Secrets Manager secrets with role-based access control.

## Overview

This module creates a JSON policy document for use with `aws_secretsmanager_secret_policy` resources.
It implements a flexible role-based access control system with three permission levels:

- **Admins**: Full access to the secret (all operations)
- **Writers**: Can list, read, and write secret values (but cannot delete, tag, or manage permissions)
- **Readers**: Can only read secret values (all other operations denied)

The module automatically includes the caller's IAM role as an admin, ensuring you don't lock yourself out of the secret.

## Features

- Role-based access control with three permission tiers
- Explicit deny statements to prevent privilege escalation
- Automatic inclusion of caller role as admin
- Compatible with AWS Provider versions 5.x and 6.x
- Follows least-privilege security principles

## Usage

### Basic Example

```hcl
module "secret_policy" {
  source = "infrahouse/secret-policy/aws"

  admins = [
    "arn:aws:iam::123456789012:role/security-team"
  ]

  writers = [
    "arn:aws:iam::123456789012:role/app-service"
  ]

  readers = [
    "arn:aws:iam::123456789012:role/monitoring"
  ]
}

resource "aws_secretsmanager_secret_policy" "example" {
  secret_arn = aws_secretsmanager_secret.example.arn
  policy     = module.secret_policy.policy_json
}
```

### Minimal Example (Caller Role Only)

```hcl
module "secret_policy" {
  source = "infrahouse/secret-policy/aws"
}

resource "aws_secretsmanager_secret_policy" "example" {
  secret_arn = aws_secretsmanager_secret.example.arn
  policy     = module.secret_policy.policy_json
}
```

### RDS Secret Example

A common use case is managing access to secrets created by RDS instances:

```hcl
module "database_secret_policy" {
  source  = "infrahouse/secret-policy/aws"
  version = "~> 1.0"

  readers = concat(
    [
      data.aws_iam_role.github_actions.arn,
      data.aws_iam_role.sso_admin.arn
    ],
    [
      for name in local.runner_names : module.github_runner[name].runner_role_arn
    ]
  )
}

resource "aws_secretsmanager_secret_policy" "database" {
  policy     = module.database_secret_policy.policy_json
  secret_arn = aws_db_instance.database.master_user_secret[0]["secret_arn"]
}
```

## Permission Levels

### Admin Permissions
- All Secrets Manager operations
- Automatically includes the IAM role making the Terraform call

### Writer Permissions
Allowed operations:
- `secretsmanager:List*` (listing secrets)
- `secretsmanager:Get*`, `secretsmanager:Describe*` (reading secret metadata and values)
- `secretsmanager:PutSecretValue`, `secretsmanager:UpdateSecret*` (writing secret values)

Denied operations:
- Delete operations
- Permission management
- Tagging operations

### Reader Permissions
Allowed operations:
- `secretsmanager:GetSecretValue`, `secretsmanager:DescribeSecret` (reading secret values)

Denied operations:
- All listing, writing, deleting, and administrative operations

## Testing

The module includes comprehensive tests for both AWS provider versions 5.x and 6.x.

```bash
# Install dependencies
make bootstrap

# Run all tests (both provider versions)
make test

# Run tests and keep resources for inspection
make test-keep

# Run tests and clean up resources
make test-clean

# Check code style
make lint

# Format code
make format
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.11, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.11, < 7.0 |

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
