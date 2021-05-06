terraform {
  required_providers {
    azuredevops = {
      source = "XenitAB/azuredevops"
      version = "0.3.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "4aff0984-efd7-4b54-9564-652d0338fa3a"
  client_id       = "af4a58c9-56a1-4830-892c-4f0e45b5bf03"
  //client_id = var.client_id
}

module "AKSCluster" {
  source = "../aksmodule"
}


provider "azuredevops" {
  version = ">= 0.0.1"
  personal_access_token = "${var.AZDO_PERSONAL_ACCESS_TOKEN}"
  org_service_url = "${var.AZDO_ORG_SERVICE_URL}"

}
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.region
  //value="justforfun"
}
resource "azuredevops_project" "project" {
  name       = "DemoforAKSInfra"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}
resource "azuredevops_git_repository" "repository" {
  project_id           = azuredevops_project.project.id
  name                 = "microservices-reference-implementation"
  initialization {
    init_type = "Import"
    source_type = "Git"
    source_url = "https://github.com/ShubhasisMathur/microservices-reference-implementation.git"
  }
}

resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.project.id
  name         = "Infrastructure Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "FOO"
    value = "BAR"
  }
}

resource "azuredevops_build_definition" "build" {
  project_id = azuredevops_project.project.id
  name       = "Sample Build Definition"
  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repository.id
    branch_name = azuredevops_git_repository.repository.default_branch
    yml_path    = "azure-pipelines.yml"
  }

  variable_groups = [
    azuredevops_variable_group.vars.id
  ]

  variable {
    name  = "PipelineVariable"
    value = "Go Microsoft!"
  }

  variable {
    name      = "PipelineSecret"
    secret_value     = "ZGV2cw"
    is_secret = true
  }
}
