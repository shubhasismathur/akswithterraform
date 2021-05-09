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
  subscription_id = "bc96fb25-0001-4aeb-a9b7-4b49f30c94f5"
  client_id       = "b04847ea-3f78-44c4-9556-d7fe0daa3560"
  //client_id = var.client_id
  client_secret   = "OEGu4gWYY7cEDZ38ggcIFhB9BmH8-4VBHF"
  tenant_id       = "79719c46-3f53-4d47-abc3-8354d0839c85"
}
//module "AKSCluster" {
 // source = "./module"
//}


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
  name       = "akswithterraformdemo"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}
resource "azuredevops_git_repository" "repository" {
  project_id           = azuredevops_project.project.id
  name                 = "akswithterraform"
  initialization {
    init_type = "Import"
    source_type = "Git"
    source_url = "https://github.com/ShubhasisMathur/akswithterraform.git"
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
