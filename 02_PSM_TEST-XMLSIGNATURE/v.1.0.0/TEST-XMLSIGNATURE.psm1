function TEST-XMLSIGNATURE {
    param (
        [string]$XmlFilePath,
        [string]$CertificateSubjectName
    )

    try {
        # Laden der XML-Datei
        $xmlDocument = New-Object System.Xml.XmlDocument
        $xmlDocument.PreserveWhitespace = $true
        $xmlDocument.Load($XmlFilePath)

        # Suche nach der Signatur im XML-Dokument
        $signedXml = New-Object System.Security.Cryptography.Xml.SignedXml($xmlDocument)

        # Finde alle Signaturen im XML-Dokument
        $signatures = $xmlDocument.GetElementsByTagName("Signature")

        if ($signatures.Count -eq 0) {
            throw "Keine Signaturen im XML-Dokument gefunden."
        }

        # Öffnen des Windows Zertifikatsspeichers für den aktuellen Benutzer
        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::My, [System.Security.Cryptography.X509Certificates.StoreLocation]::CurrentUser)
        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)

        # Zertifikatsauswahl über den Common Name (cn)
        $certificates = $store.Certificates.Find([System.Security.Cryptography.X509Certificates.X509FindType]::FindBySubjectName, $CertificateSubjectName, $false)

        if ($certificates.Count -eq 0) {
            throw "Zertifikat mit dem angegebenen Common Name wurde im Zertifikatsspeicher nicht gefunden."
        }

        # Das erste gefundene Zertifikat auswählen (falls es mehrere mit dem gleichen Common Name gibt)
        $certificate = $certificates[0]

        # Validierung jeder Signatur im XML-Dokument
        foreach ($signature in $signatures) {
            $signedXml.LoadXml($signature)
            $isValid = $signedXml.CheckSignature($certificate.PublicKey.Key)

            if ($isValid) {
                Write-Host "Die Signatur ist gültig."
            } else {
                Write-Host "Die Signatur ist ungültig."
            }
        }
    }
    catch {
        Write-Host "Fehler bei der Signaturüberprüfung: $_"
    }
    finally {
        # Schließen des Zertifikatsspeichers, um Ressourcen freizugeben
        if ($store) {
            $store.Close()
        }
    }
}
