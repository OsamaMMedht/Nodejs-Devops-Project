# Set variables
$cluster_name = "nodejs-cluster-test"
$region = "us-east-1"
$aws_id = "902597156506"
$repo_name = "nodejs-app"
$image_name = "$aws_id.dkr.ecr.$region.amazonaws.com/$repo_name:latest"
$domain = "osocp.click"
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
cd terraform
terraform init
terraform apply -auto-approve
cd ..

# Update kubeconfig
Write-Host "--------------------Update Kubeconfig--------------------"
aws eks update-kubeconfig --name $cluster_name --region $region

# Remove previous Docker image
Write-Host "--------------------Remove Previous build--------------------"
docker rmi -f $image_name 2>$null

# Build Docker image
Write-Host "--------------------Build new Image--------------------"
docker build -t $image_name .

# Login to ECR
Write-Host "--------------------Login to ECR--------------------"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin "$aws_id.dkr.ecr.$region.amazonaws.com"

# Push Docker image
Write-Host "--------------------Pushing Docker Image--------------------"
docker push $image_name

# Create namespace
Write-Host "--------------------Creating Namespace--------------------"
kubectl create ns $namespace 2>$null

# Generate DB password
Write-Host "--------------------Generate DB password--------------------"
$PASSWORD = [System.Convert]::ToBase64String((New-Object byte[] 9 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 }))

# Store password in K8s secret
Write-Host "--------------------Store the generated password in k8s secret--------------------"
kubectl create secret generic $dbsecret --from-literal=DB_PASSWORD=$PASSWORD --namespace=$namespace 2>$null

# Deploy the app
Write-Host "--------------------Deploy App--------------------"
kubectl apply -n $namespace -f k8s

# Wait for pods
Write-Host "--------------------Wait for all pods to be running--------------------"
Start-Sleep -Seconds 60

# Get Ingress URL
Write-Host "--------------------Ingress URL--------------------"
$ingress = kubectl get ingress nodejs-app-ingress -n $namespace -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
Write-Host $ingress
Write-Host ""

# Output URLs
Write-Host "--------------------Application URL--------------------"
Write-Host "http://nodejs.$domain"
Write-Host ""

Write-Host "--------------------Alertmanager URL--------------------"
Write-Host "http://alertmanager.$domain"
Write-Host ""

Write-Host "--------------------Prometheus URL--------------------"
Write-Host "http://prometheus.$domain"
Write-Host ""

Write-Host "--------------------Grafana URL--------------------"
Write-Host "http://grafana.$domain"
Write-Host ""

# Instructions for DNS
Write-Host "1. Navigate to your domain cPanel"
Write-Host "2. Go to Zone Editor"
Write-Host "3. Add a CNAME record"
Write-Host "4. Set the name as your app's subdomain (e.g. nodejs)"
Write-Host "5. Set the CNAME value to the ingress URL above"
