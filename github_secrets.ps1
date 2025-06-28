# Set your GitHub repo details
$OWNER = "OsamaMMedht"
$REPO = "Nodejs-Devops-Project"

# Read AWS credentials from the credentials file
$AWS_ACCESS_KEY_ID = (Select-String -Path "$env:USERPROFILE\.aws\credentials" -Pattern "aws_access_key_id" | ForEach-Object { ($_ -split "=")[1].Trim() })
$AWS_SECRET_ACCESS_KEY = (Select-String -Path "$env:USERPROFILE\.aws\credentials" -Pattern "aws_secret_access_key" | ForEach-Object { ($_ -split "=")[1].Trim() })

# Function to create or update GitHub secret
function Create-Secret {
    param (
        [string]$SecretName,
        [string]$SecretValue
    )

    Write-Host "Setting secret $SecretName..."

    $result = echo $SecretValue | gh secret set $SecretName --repo "$OWNER/$REPO"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Secret $SecretName set successfully."
    } else {
        Write-Host "Failed to set secret $SecretName."
        exit 1
    }
}

# Call the function with each AWS credential
Create-Secret -SecretName "AWS_ACCESS_KEY_ID" -SecretValue $AWS_ACCESS_KEY_ID
Create-Secret -SecretName "AWS_SECRET_ACCESS_KEY" -SecretValue $AWS_SECRET_ACCESS_KEY

Write-Host "AWS credentials stored as GitHub secrets in the repository $OWNER/$REPO"