resource "tfe_registry_module" "pet_name" {
  organization = local.organization

  vcs_repo {
    display_identifier         = "mkdatz14/terraform-random-pet-name"
    identifier                 = "mkdatz14/terraform-random-pet-name"
    github_app_installation_id = local.github_app_installation_id
    oauth_token_id             = local.github_app_installation_id == null ? local.github_oauth_token_id : null
    branch                     = "main"
    tag_prefix                 = "v"
  }
}
