# Set variables
$cluster_name = "cluster-1-test"
$region = "REGION" # Replace with your region
$aws_id = "AWS_ID" # Replace with your AWS account ID
$repo_name = "nodejs-app"
$image_name = "$aws_id.dkr.ecr.$region.amazonaws.com/$repo_name:latest"
$domain = "YOUR_DOMAIN"
$dbsecret = "db-password-secret"
$namespace = "nodejs-app"

# Update Helm repos
helm repo update

# Deploy Terraform resources
Write-Host "--------------------Creating EKS--------------------"
Write-Host "--------------------Creating ECR--------------------"
Write-Host "--------------------Creating EBS--------------------"
Write-Host "--------------------Deploying Ingress--------------------"
Write-Host "--------------------Deploying Monitoring--------------------"
Set-Location terraform
terraform init
terraform apply -auto-approve
Set-Location ..

# Update kubeconfig
Write-Host "--------------------Update Kubeconfig--------------------"
aws eks update-kubeconfig --name $cluster_name --region $region

# Remove previous Docker i