# Define the certificate store name (you can change this if needed)
$certStoreName = "Root" # Change to "Root" or "CA" if you're working with those stores

# Get all certificates from the specified store
$certificates = Get-ChildItem -Path "Cert:\LocalMachine\$certStoreName" | Where-Object { $_.GetType().Name -eq "X509Certificate2" }

# Create an array to store unique thumbprints
$uniqueThumbprints = @()

# Iterate through the certificates and remove duplicates
foreach ($cert in $certificates) {
    $thumbprint = $cert.Thumbprint
    if ($uniqueThumbprints -contains $thumbprint) {
        # Certificate is a duplicate, so remove it
        Write-Host "Removing duplicate certificate with thumbprint: $thumbprint"
        Remove-Item -Path ("Cert:\LocalMachine\$certStoreName\" + $cert.Thumbprint) -Force
    } else {
        # Add the thumbprint to the uniqueThumbprints array
        $uniqueThumbprints += $thumbprint
    }
}

Write-Host "Duplicate certificates removed from the $certStoreName store."