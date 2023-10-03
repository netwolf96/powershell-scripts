function Compare-Hashes {

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

    # List files from the folder
    $files = Get-ChildItem -Path $folderPath -File -Recurse

    # Read XML file
    $xml = [xml](Get-Content -Path $hashesXMLPath)

    # Create a hashtable to store the XML hashes
    $hashesFromXML = @{}

    # Create list of files in the XML file
    $xmlFileNames = $xml.HashValues.File.Name

    foreach ($hashNode in $xml.HashValues.File) {
        $name = $hashNode.Name
        $value = $hashNode.Hash.value
        $hashesFromXML[$name] = $value
    }

    # Variable to store the status of the hash check.
    $allHashesIdentical = $true

    # variable to store files with different hashes
    $differentHashesFiles = @()

    foreach ($file in $files) {
        $fileHash = Get-FileHash -Path $file.FullName -Algorithm SHA256
        $fileName = $file.Name

        # Retrieve hash from the XML file for the current file (if it exists).
        $xmlHash = $hashesFromXML[$fileName]

        if ($null -ne $xmlHash -and $fileHash.Hash -ne $xmlHash) {
            $allHashesIdentical = $false
            $differentHashesFiles += $file.FullName
        }
    }

    # Create a list of files in the directory
    $directoryFileNames = $files.Name

    # Check if any files are missing or added
    $missingFiles = Compare-Object -ReferenceObject $xmlFileNames -DifferenceObject $directoryFileNames

    if ($allHashesIdentical -eq $true -and $missingFiles.Count -eq 0) 
    {
        Write-Host "Alle Hashes sind identisch, und keine Dateien fehlen oder wurden hinzugefügt." -ForegroundColor Green
    } 
    
    else 
    {
        Write-Host "At least one hash is different or files are missing or have been added." -ForegroundColor Red
        Write-Host "List of the files with different hashes:" -ForegroundColor Yellow
        $differentHashesFiles | ForEach-Object {
            Write-Host $_ -ForegroundColor Yellow
        }
        Write-Host "List of the missing/added files:" -ForegroundColor Red
        $missingFiles | ForEach-Object {
            Write-Host $_.InputObject -ForegroundColor Yellow
        }
    }
}