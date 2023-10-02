## Changelog for "Remove-DuplicateCertificates" Script

### Version 1.0.0 - Released on 02.10.2023

#### Added
- Initial implementation of the "Remove-DuplicateCertificates" script for removing duplicate X.509 certificates from the local machine's certificate store.

#### Features
- The script defines a certificate store name, allowing users to change it as needed. By default, it is set to "Root," but it can be changed to "CA" or other store names.
- Retrieves all certificates from the specified certificate store, based on the configured store name.
- Creates an array to store unique thumbprints of certificates.
- Iterates through the certificates and removes duplicates by comparing thumbprints.
- Displays information about removed duplicate certificates.

#### Usage
```powershell
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