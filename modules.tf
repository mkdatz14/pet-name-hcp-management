resource "tfe_registry_module" "pet_name" {
    organization = local.organization

    vcs_repo {
        display_identifier = "mkdatz/terraform-random-pet-name"
        identifier = "mkdatz/terraform-random-pet-name"
        oauth_token_id = data.tfe_outputs.hcp_management.outputs.github_token_id
        branch = "main"
    }
}
