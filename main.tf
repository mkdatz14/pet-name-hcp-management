locals { 
    organization = "mkdatz"
}

provider "tfe" {}

data "tfe_organization" "org" {
    name = local.organization
}

data "tfe_outputs" "hcp_management" {
    organization = local.organization
    workspace = "hcp-terraform-management"
}
