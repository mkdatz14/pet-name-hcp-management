variable "variable_sets_yaml" {
  description = "YAML content that defines HCP Terraform variable sets, variables, and attachments. When set, this takes precedence over variable_sets_yaml_path."
  type        = string
  default     = ""
}

variable "variable_sets_yaml_path" {
  description = "Path to a YAML file that defines HCP Terraform variable sets, variables, and attachments."
  type        = string
  default     = "variable-sets.yaml"
}