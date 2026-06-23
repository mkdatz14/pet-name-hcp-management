# pet-name-hcp-management
Terraform for managing an example pet name project.

## Workspace run behavior

Deployment workspaces remain VCS-connected to the `mkdatz14/pet-name-infra` repository and keep their existing branch mapping:

- `dev1`, `dev2`, `dev3` track the `dev` branch.
- `staging1`, `staging2`, `staging3` track the `staging` branch.
- `prod1`, `prod2`, `prod3` track the `prod` branch.

These workspaces now set `queue_all_runs = false`. This preserves the VCS linkage and branch-backed configuration version updates, but stops HCP Terraform from automatically queuing runs from VCS webhook events on branch merges.

Deployments are expected to be started manually by the targeted GitHub Actions workflow, which can queue only the requested deployment workspaces such as `dev2` or `staging1,staging3`.

This change does not use trigger prefixes or trigger patterns. Those settings only filter which file changes can start a VCS-triggered run; they do not disable the automatic queueing behavior.

## YAML-driven variable sets

Variable sets can be defined from YAML instead of hard-coded Terraform resources. By default, Terraform looks for `variable-sets.yaml` in this directory. You can also pass the YAML content directly with the `variable_sets_yaml` Terraform variable; direct YAML content takes precedence over the file path.

Start from `variable-sets.yaml.example`:

```yaml
variable_sets:
	dev:
		name: pet-name-dev
		description: Variables shared by pet-name development workspaces.
		projects:
			- dev
		variables:
			environment:
				value: dev
				category: terraform
				description: Environment name for development workspaces.
```

Each variable set supports these fields:

- `name`: HCP Terraform variable set name. Defaults to `pet-name-<set key>`.
- `description`: Optional variable set description.
- `global`: Optional boolean. Defaults to `false`.
- `projects`: Optional list of project keys to attach to. Supported keys are `dev`, `staging`, `prod`, and `shared`.
- `workspaces`: Optional list of workspace keys to attach to. Supported keys are `dev1`, `dev2`, `dev3`, `staging1`, `staging2`, `staging3`, `prod1`, `prod2`, and `prod3`.
- `variables`: Map of variables to create in the variable set.

Each variable supports these fields:

- `key`: Optional HCP Terraform variable key. Defaults to the YAML map key.
- `value`: Required variable value. Lists and maps are JSON-encoded.
- `category`: Optional category, usually `terraform` or `env`. Defaults to `terraform`.
- `description`: Optional variable description.
- `hcl`: Optional boolean for HCL variable values. Defaults to `false`.
- `sensitive`: Optional boolean. Defaults to `false`.

Variable sets are best for shared, stable values. User-provided values that change per deployment should still be handled by the deployment workflow or workspace-specific variables, because variable set values are persistent.

## Registry module tagging note

For `tfe_registry_module`, HCP Terraform requires `branch` to be unset when `tag_prefix` is configured. If both are set, updates can fail with "VCS branch must be empty to enable tags".
