function TEST-XMLSIGNATURE {
    
<#
.SYNOPSIS
This function verifies the digital signatures in an XML file using a specified certificate.

.DESCRIPTION
The TEST-XMLSIGNATURE function verifies digital signatures in an XML file using the X.509 certificate's public key. It searches for "Signature" elements in the XML file and validates each signature using the specified certificate's public key. If the signatures are valid, the function will display a success message; otherwise, it will indicate that the signature is invalid or any encountered errors.

.PARAMETER XmlFilePath
Specifies the path of the XML file containing the digital signatures to be verified.

.PARAMETER CertificateSubjectName
Specifies the subject name (common name) of the X.509 certificate used for signature validation.

.EXAMPLE
TEST-XMLSIGNATURE -XmlFilePath "C:\path\to\example.xml" -CertificateSubjectName "CN=ExampleCertificate"

This example runs the function to verify digital signatures in the XML file located at "C:\path\to\example.xml". It uses the X.509 certificate with the subject name "CN=ExampleCertificate" for signature validation.

.NOTES
Copyright © 2023 netzack-it. All rights reserved. This script is provided "as-is" without any warranties or guarantees. Use at your own risk.
#>
    
    param (
        [Parameter(Mandatory=$true)]
        [string]$XmlFilePath,
        [Parameter(Mandatory=$true)]
        [string]$CertificateSubjectName
    )

    # Loading the required .NET classes
    Add-Type -AssemblyName System.Security
    Add-Type -AssemblyName System.Xml

    try {
        # Load the XML file
        $xmlDocument = New-Object System.Xml.XmlDocument
        $xmlDocument.PreserveWhitespace = $true
        $xmlDocument.Load($XmlFilePath)

        # Search for the signature in XML document
        $signedXml = New-Object System.Security.Cryptography.Xml.SignedXml($xmlDocument)

        # Find all signatures in the XML document
        $signatures = $xmlDocument.GetElementsByTagName("Signature")

        if ($signatures.Count -eq 0) {
            throw "No signatures found in XML document."
        }

        # Open the Windows certificate store for the current user
        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::My, [System.Security.Cryptography.X509Certificates.StoreLocation]::CurrentUser)
        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)

        # Certificate selection via the common name (cn)
        $certificates = $store.Certificates.Find([System.Security.Cryptography.X509Certificates.X509FindType]::FindBySubjectName, $CertificateSubjectName, $false)

        if ($certificates.Count -eq 0) {
            throw "Certificate with the specified common name was not found in the certificate store."
        }

        # Select the first certificate found (if there are several with the same common name)
        $certificate = $certificates[0]

        # Validation of each signature in the XML document
        foreach ($signature in $signatures) {
            $signedXml.LoadXml($signature)
            $isValid = $signedXml.CheckSignature($certificate.PublicKey.Key)

            if ($isValid) {
                Write-Host "Signature is valid." -ForegroundColor Green -Debug
            } else {
                Write-Host "Signature is invalid." -ForegroundColor Red -Debug
            }
        }
    }
    catch {
        Write-Host "Signature verification error: $_" -ForegroundColor Red -Debug
    }
    finally {
        # Closing the certificate store to free resources
        if ($store) {
            $store.Close()
        }
    }
}