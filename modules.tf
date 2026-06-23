resource "tfe_registry_module" "pet_name" {
  organization = local.organization

  vcs_repo {
    display_identifier = "mkdatz14/terraform-random-pet-name"
    identifier         = "mkdatz14/terraform-random-pet-name"
    # Use org OAuth for module registry access; this repo may not be installed in the GitHub App.
    github_app_installation_id = null
    oauth_token_id             = local.github_oauth_token_id
    tag_prefix                 = "v"
  }
}
