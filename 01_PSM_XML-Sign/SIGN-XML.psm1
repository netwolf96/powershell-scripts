function SIGN-XML {
    param(
        [string]$xmlFilePath,
        [string]$certificateCommonName
    )

    # Loading the required .NET classes
    Add-Type -AssemblyName System.Security

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

    Write-Host "XML file successfully signed and saved using the user certificate (CN: $certificateCommonName): $signedXmlFilePath"
}