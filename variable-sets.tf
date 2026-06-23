locals {
  variable_sets_yaml_from_file = var.variable_sets_yaml == "" && fileexists(var.variable_sets_yaml_path) ? file(var.variable_sets_yaml_path) : ""
  variable_sets_yaml_source    = trimspace(var.variable_sets_yaml) != "" ? var.variable_sets_yaml : local.variable_sets_yaml_from_file
  variable_sets_config         = trimspace(local.variable_sets_yaml_source) != "" ? yamldecode(local.variable_sets_yaml_source) : {}
  variable_sets                = try(local.variable_sets_config.variable_sets, {})

  variable_set_project_ids = {
    dev     = tfe_project.dev.id
    staging = tfe_project.staging.id
    prod    = tfe_project.prod.id
    shared  = tfe_project.shared.id
  }

  variable_set_workspace_ids = {
    for workspace_key, workspace in tfe_workspace.pet_name :
    workspace_key => workspace.id
  }

  variable_set_project_attachments = merge([
    for variable_set_key, variable_set in local.variable_sets : {
      for project_key in try(variable_set.projects, []) :
      "${variable_set_key}.${project_key}" => {
        variable_set_key = variable_set_key
        project_key      = project_key
      }
    }
  ]...)

  variable_set_workspace_attachments = merge([
    for variable_set_key, variable_set in local.variable_sets : {
      for workspace_key in try(variable_set.workspaces, []) :
      "${variable_set_key}.${workspace_key}" => {
        variable_set_key = variable_set_key
        workspace_key    = workspace_key
      }
    }
  ]...)

  variable_set_variables = merge([
    for variable_set_key, variable_set in local.variable_sets : {
      for variable_key, variable_config in try(variable_set.variables, {}) :
      "${variable_set_key}.${variable_key}" => {
        variable_set_key = variable_set_key
        variable_key     = variable_key
        config           = variable_config
      }
    }
  ]...)
}

resource "tfe_variable_set" "pet_name" {
  for_each = local.variable_sets

  name         = try(each.value.name, "pet-name-${each.key}")
  description  = try(each.value.description, null)
  global       = try(each.value.global, false)
  organization = local.organization
}

resource "tfe_project_variable_set" "pet_name" {
  for_each = local.variable_set_project_attachments

  project_id      = local.variable_set_project_ids[each.value.project_key]
  variable_set_id = tfe_variable_set.pet_name[each.value.variable_set_key].id
}

resource "tfe_workspace_variable_set" "pet_name" {
  for_each = local.variable_set_workspace_attachments

  workspace_id    = local.variable_set_workspace_ids[each.value.workspace_key]
  variable_set_id = tfe_variable_set.pet_name[each.value.variable_set_key].id
}

resource "tfe_variable" "pet_name_variable_set" {
  for_each = local.variable_set_variables

  key             = try(each.value.config.key, each.value.variable_key)
  value           = try(tostring(each.value.config.value), jsonencode(each.value.config.value))
  category        = try(each.value.config.category, "terraform")
  description     = try(each.value.config.description, null)
  hcl             = try(each.value.config.hcl, false)
  sensitive       = try(each.value.config.sensitive, false)
  variable_set_id = tfe_variable_set.pet_name[each.value.variable_set_key].id
}