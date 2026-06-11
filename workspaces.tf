locals {
    pet_name_envs = {
        dev1 = {tier = "dev", branch = "dev", auto_apply = true},
        dev2 = {tier = "dev", branch = "dev", auto_apply = true},
        dev3 = {tier = "dev", branch = "dev", auto_apply = true},
        staging1 = {tier = "staging", branch = "staging", auto_apply = false},
        staging2 = {tier = "staging", branch = "staging", auto_apply = false},
        staging3 = {tier = "staging", branch = "staging", auto_apply = false},
        prod1 = {tier = "prod", branch = "prod", auto_apply = false},
        prod2 = {tier = "prod", branch = "prod", auto_apply = false},
        prod3 = {tier = "prod", branch = "prod", auto_apply = false},
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
    queue_all_runs = false

    vcs_repo {
        identifier = local.pet_name_repo
        github_app_installation_id = local.github_app_installation_id
        oauth_token_id = local.github_app_installation_id == null ? local.github_oauth_token_id : null
        branch = each.value.branch
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
