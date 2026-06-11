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
