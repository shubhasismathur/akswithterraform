# akswithterraform

AKS with Terraform
Pipeline
On every code change -

1. Docker Build
2. Helm Chart Upload
3. AKS Creation - cluster info terraform apply
4. Helm App Deployment
5. Validation of Application (Regression Suite)
6. Terraform destroy


#
terraform init
terraform apply #-auto-approve
terraform destroy