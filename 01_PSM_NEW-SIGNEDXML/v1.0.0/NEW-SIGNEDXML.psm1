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
	
	param(
        [Parameter(Mandatory=$true)]
		[string]$xmlFilePath,
        [Parameter(Mandatory=$true)]
		[string]$certificateCommonName
    )

    # Loading the required .NET classes
    Add-Type -AssemblyName System.Security
    Add-Type -AssemblyName System.Xml

    # Search for certificates in the user certificate store
    $certs = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Subject -like "*CN=$certificateCommonName*" }

    if ($certs.Count -eq 0) {
        Write-Host "No certificate with the common name $certificateCommonName was found in the user certificate store."
        return
    }

    # Let's take the first certificate found with the corresponding common name
    $cert = $certs[0]

    # Loading the XML file
    $xmlDocument = New-Object System.Xml.XmlDocument
    $xmlDocument.PreserveWhitespace = $true
    $xmlDocument.Load($xmlFilePath)

    # Create the SignedXml object
    $signedXml = New-Object System.Security.Cryptography.Xml.SignedXml($xmlDocument)

    # Adding the certificate to the SignedXml object
    $signedXml.SigningKey = $cert.PrivateKey

    # Create a reference to the entire XML file
    $reference = New-Object System.Security.Cryptography.Xml.Reference
    $reference.Uri = ""

    # Adding the hash algorithm to the reference (SHA-256)
    $reference.DigestMethod = [System.Security.Cryptography.Xml.SignedXml]::XmlDsigSHA256Url

    # Adding the reference to the SignedXml object
    $signedXml.AddReference($reference)

    # Set the XML document context for the reference
    $signedXml.Signature.SignedInfo.AddReference($reference)

    # Compute the signature
    $signedXml.ComputeSignature()

    # Adding the XML signature to the XML document
    $xmlDocument.DocumentElement.AppendChild($xmlDocument.ImportNode($signedXml.GetXml(), $true))

    # Save the signed XML file
    $signedXmlFilePath = $xmlFilePath -replace ".xml$", "_signed.xml"
    $xmlDocument.Save($signedXmlFilePath)

    Write-Host "XML file successfully signed and saved using the user certificate (CN: $certificateCommonName): $signedXmlFilePath" -ForegroundColor Green
}