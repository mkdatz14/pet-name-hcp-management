locals {
    pet_name_envs = {
        dev1 = {tier = "dev", auto_apply = true},
        dev2 = {tier = "dev", auto_apply = true},
        dev3 = {tier = "dev", auto_apply = true},
        staging1 = {tier = "staging", auto_apply = false},
        staging2 = {tier = "staging", auto_apply = false},
        staging3 = {tier = "staging", auto_apply = false},
        prod1 = {tier = "prod", auto_apply = false},
        prod2 = {tier = "prod", auto_apply = false},
        prod3 = {tier = "prod", auto_apply = false},
    }

    tier_projects = {
        dev = tfe_project.dev.id,
        staging = tfe_project.staging.id,
        prod = tfe_project.prod.id
    }
}

resource "tfe_workspace" "pet_name" {
    for_each = local.pet_name_envs

    organization = local.organization
    name = "pet-name-${each.key}"
    project_id = local.tier_projects[each.value.tier]

    vcs_repo {
        identifier = "mkdatz14/pet-name-infra"
        oauth_token_id = data.tfe_outputs.hcp_management.values.github_token_id
        branch = "main"
    }

    auto_apply = each.value.auto_apply
}

resource "tfe_variable" "pet_name_prefix" {
    for_each = local.pet_name_envs

    key = "prefix"
    value = each.key
    category = "terraform"
    description = "Prefix for random pet name"
    workspace_id = tfe_workspace.pet_name[each.key].id
}
