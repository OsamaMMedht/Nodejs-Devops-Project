# Variables
$REGION = "us-east-1" # Make sure this matches your Terraform config
$REPOSITORY_NAME = "nodejs-app"

# Empty AWS ECR
Write-Host "--------------------Empty AWS ECR--------------------"
.\ecr-img-delete.ps1 $REGION $REPOSITORY_NAME

# Destroy AWS resources using Terraform
Write-Host "--------------------Deleting AWS Resources--------------------"
Set-Location terraform
terraform destroy -auto-approve
Set-Location ..