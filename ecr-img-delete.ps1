param (
    [string]$REGION,
    [string]$REPOSITORY_NAME
)

# Get list of image digests
$imageList = aws ecr list-images --repository-name $REPOSITORY_NAME --region $REGION --query "imageIds[*]" --output json | ConvertFrom-Json

foreach ($image in $imageList) {
    $digest = $image.imageDigest
    if ($digest) {
        Write-Host "Deleting image: $digest"
        aws ecr batch-delete-image --repository-name $REPOSITORY_NAME --region $REGION --image-ids @{ imageDigest = $digest }
    }
}