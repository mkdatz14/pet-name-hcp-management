locals {
  organization               = "mkdatz"
  pet_name_repo              = "mkdatz14/pet-name-infra"
  github_app_installation_id = try(data.tfe_outputs.hcp_management.values.github_app_installation_id, null)
  github_oauth_token_id      = try(data.tfe_outputs.hcp_management.values.github_token_id, null)
}

provider "tfe" {}

data "tfe_organization" "org" {
  name = local.organization
}

data "tfe_outputs" "hcp_management" {
  organization = local.organization
  workspace    = "hcp-terraform-management"
}
