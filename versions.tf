terraform {
  required_version = ">= 1.9"

  cloud {
    organization = "mkdatz"

    workspaces {
      name = "pet-name-hcp-management"
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.62"
    }
  }
}
