variable "admins" {
  description = "List of role ARNs that will have all permissions of the secret."
  default     = null
  type        = list(string)
}

variable "readers" {
  description = "List of role ARNs that will have read permissions of the secret."
  default     = null
  type        = list(string)
}

variable "writers" {
  description = "List of role ARNs that will have write permissions of the secret."
  default     = null
  type        = list(string)
}
