module "test_module" {
  source  = "./../../"
  admins  = [data.aws_iam_role.test_role.arn]
  writers = [data.aws_iam_role.test_role.arn]
  readers = [data.aws_iam_role.test_role.arn]
}
