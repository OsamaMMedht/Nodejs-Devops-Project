# Variables
$REGION = "REGION" # Make sure this matches your Terraform config
$REPOSITORY_NAME = "nodejs-app"

# Get S3 bucket name from Terraform output
Set-Location terraform
$BUCKET_NAME = terraform output -raw bucket_name
Set-Location ..

# Empty AWS ECR
Write-Host "--------------------Empty AWS ECR--------------------"
.\ecr-img-delete.ps1 $REGION $REPOSITORY_NAME

# Destroy AWS resources using Terraform
Write-Host "--------------------Deleting AWS Resources--------------------"
Set-Location terraform
terraform destroy -auto-approve
Set-Location ..