variable "AZDO_PERSONAL_ACCESS_TOKEN" {
  //type = list
  default = "xxxxxx"
}
variable "AZDO_ORG_SERVICE_URL" {
  default = "https://dev.azure.com/shmat0001"
}
variable "TENANT_ID" {
  default = "72f988bf-86f1-41af-91ab-2d7cd011db47"
}
//AZDO_PERSONAL_ACCESS_TOKEN=<Personal Access Token>
//export AZDO_ORG_SERVICE_URL=https://dev.azure.com/<Your Org Name>
variable "prefix" {
  //type = list
  default = "testing"
}
variable "region" {
  default = "eastus"
}
