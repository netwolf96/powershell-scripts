﻿function Compare-Hashes {
   
    <#
        .SYNOPSIS
        This is a PowerShell function that compares hash values of files in a specified folder with the hash values in an XML file.

        .DESCRIPTION
        This function compares the hash values of files in a specified folder with the hash values specified in an XML file. It indicates whether all hash values are identical or whether at least one hash value is different.

        .PARAMETER folderPath
        The path to the folder whose files are to be compared with the hash values in the XML file. This parameter is required.

        .PARAMETER hashesXMLPath
        The path to the XML file containing the hash values of the files to be compared. This parameter is required.

        .EXAMPLE
        # Example call of the function
        Compare-Hashes -folderPath "C:\FolderPath\" -hashesXMLPath "C:\HashXMLPath\HashXML.xml"

        .NOTES
        Copyright © 2023 netzack-it. All rights reserved. This script is provided "as is", without any warranties or guarantees. Use it at your own risk.
    #>
   
   param (
        [Parameter(Mandatory=$true)]
        [string]$folderPath,
        [Parameter(Mandatory=$true)]
        [string]$hashesXMLPath
    )

    # List files from folder
    $files = Get-ChildItem -Path $folderPath -File -Recurse

    # Read XML file
    $xml = [xml](Get-Content -Path $hashesXMLPath)

    # Create a hashtable to store the XML hashes
    $hashesFromXML = @{}
    
    foreach ($hashNode in $xml.HashValues.File) 
    {
        $name = $hashNode.Name
        $value = $hashNode.Hash.value
        $hashesFromXML[$name] = $value
    }

    # Variable to store the status of the hash check.
    $allHashesIdentical = $true

    # variable to store files with different hashes
    $differentHashesFiles = @()

    foreach ($file in $files) 
    {
        $fileHash = Get-FileHash -Path $file.FullName -Algorithm SHA256
        $fileName = $file.Name

        # Get hash from XML file for current file
        $xmlHash = $hashesFromXML[$fileName]

        if ($xmlHash -ne $null -and $fileHash.Hash -ne $xmlHash) 
        {
            $allHashesIdentical = $false
            $differentHashesFiles += $file.FullName
        }
    }

    if ($allHashesIdentical -eq $true) 
    {
        Write-Host "Alle Hashes sind identisch."
    } 

    else 
    {
        Write-Host "Mindestens ein Hash ist unterschiedlich."
        Write-Host "Liste der Dateien mit unterschiedlichen Hashes:"
        $differentHashesFiles | ForEach-Object {
            Write-Host $_
        }
    }
}