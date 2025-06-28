# Set variables
$CLUSTER_NAME = "cluster-1-test"
$NAMESPACE = "default"
$REGION = "us-east-1"
$RELEASE_NAME = "my-argo-cd"

# Update kubeconfig
Write-Host "--------------------Update kubeconfig--------------------"
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION

# Deploy ArgoCD on EKS
Write-Host "--------------------Deploy ArgoCD on EKS--------------------"
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install $RELEASE_NAME argo/argo-cd

# Wait 60 seconds
Write-Host "--------------------Wait for the pods to start--------------------"
Start-Sleep -Seconds 60

# Change Service to LoadBalancer
Write-Host "--------------------Change Argocd Service to LoadBalancer--------------------"
kubectl patch svc "$RELEASE_NAME-argocd-server" -n $NAMESPACE -p '{"spec": {"type": "LoadBalancer"}}'

# Wait 10 seconds
Write-Host "--------------------Creating External-IP--------------------"
Start-Sleep -Seconds 10

# Reveal ArgoCD External IP
Write-Host "--------------------ArgoCD Ex-URL--------------------"
$svc = kubectl get service "$RELEASE_NAME-argocd-server" -n $NAMESPACE
$externalIP = ($svc -split "`n")[1] -split "\s+" | Select-Object -Index 3
Write-Host "External IP: $externalIP"

# Reveal ArgoCD UI Password
Write-Host "--------------------ArgoCD UI Password--------------------"
Write-Host "Username: admin"
$encodedPassword = kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
$decodedPassword = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encodedPassword))
$decodedPassword | Out-File -Encoding ascii argo-pass.txt
Write-Host "Password saved to argo-pass.txt"