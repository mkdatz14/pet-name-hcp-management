resource "tfe_project" "dev" {
    organization = local.organization
    name = "Pet Name - dev"
}

resource "tfe_project" "prod" {
    organization = local.organization
    name = "Pet Name - prod"
}

resource "tfe_project" "staging" {
    organization = local.organization
    name = "Pet Name - staging"
}
