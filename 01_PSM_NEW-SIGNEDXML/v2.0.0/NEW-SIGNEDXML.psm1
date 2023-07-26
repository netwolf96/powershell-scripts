function NEW-SIGNEDXML {
    
    	<#
	.SYNOPSIS
	Signs an XML file using a user certificate and saves the signed XML to a new file.
	
	.DESCRIPTION
	The NEW-SIGNEDXML function loads an XML file and signs it using a certificate with the specified common name (CN). The signed XML is saved to a new file with "_signed" appended to the original file name.
	
	.PARAMETER xmlFilePath
	Specifies the path to the XML file that needs to be signed.
	
	.PARAMETER certificateCommonName
	Specifies the common name (CN) of the certificate to be used for signing. The function searches for the certificate in the user certificate store based on the provided common name.
	
	.EXAMPLE
	NEW-SIGNEDXML -xmlFilePath "C:\Files\Document.xml" -certificateCommonName "MyCertificate"
	Signs the XML file "C:\Files\Document.xml" using the certificate with the common name "MyCertificate" and saves the signed XML to "C:\Files\Document_signed.xml".
	
	.NOTES
	This function requires the .NET classes from the System.Security namespace for signing the XML using a certificate.
    
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
        # Loading the XML file
        $xmlDocument = New-Object System.Xml.XmlDocument
        $xmlDocument.PreserveWhitespace = $true
        $xmlDocument.Load($XmlFilePath)

        # Open the Windows certificate store for the current user
        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::My, [System.Security.Cryptography.X509Certificates.StoreLocation]::CurrentUser)
        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)

        # Certificate selection via the common name (cn)
        $certificates = $store.Certificates.Find([System.Security.Cryptography.X509Certificates.X509FindType]::FindBySubjectName, $CertificateSubjectName, $false)

        if ($certificates.Count -eq 0) {
            throw "Zertifikat mit dem angegebenen Common Name wurde im Zertifikatsspeicher nicht gefunden."
        }

        # Select the first certificate found (if there are several with the same common name)
        $certificate = $certificates[0]

        # Extracting the RSA key
        $rsaPrivateKey = $certificate.PrivateKey

        # Create the XML signature
        $signedXml = New-Object System.Security.Cryptography.Xml.SignedXml($xmlDocument)

        # Adding the RSA key to sign
        $signedXml.SigningKey = $rsaPrivateKey

        # Set the signature method to SHA-256
        $signedXml.SignedInfo.SignatureMethod = "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"

        # Create the reference to the data to be signed
        $reference = New-Object System.Security.Cryptography.Xml.Reference
        $reference.Uri = ""
        $reference.AddTransform([System.Security.Cryptography.Xml.XmlDsigEnvelopedSignatureTransform]::new())
        $reference.AddTransform([System.Security.Cryptography.Xml.XmlDsigExcC14NTransform]::new())
        $signedXml.AddReference($reference)

        # Calculate the signature
        $signedXml.ComputeSignature()

        # Adding the signature to the XML document
        $xmlDocument.DocumentElement.AppendChild($xmlDocument.ImportNode($signedXml.GetXml(), $true))

        $signedXmlFilePath = $XmlFilePath -replace "\.xml$", "_signed.xml"

        # Save the signed XML
        $xmlDocument.Save($signedXmlFilePath)

        Write-Host "The XML file was successfully signed and saved as $signedXmlFilePath." -ForegroundColor Green -Debug
    }
    catch {
        Write-Host "Error while signing the XML file: $_" -ForegroundColor Red -Debug
    }
    finally {
        # Closing the certificate store to free resources
        if ($store) {
            $store.Close()
        }
    }
}
