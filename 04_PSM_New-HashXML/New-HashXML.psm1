function New-HashXML 
{

   <#
    .SYNOPSIS
    Generates an XML file containing the hash values (SHA256) of files in a given directory.

    .DESCRIPTION
    This function recursively scans a directory and creates an XML file that includes the file names and their corresponding SHA256 hash values.

    .PARAMETER directory
    The directory path where the files are located.

    .PARAMETER xmlPath
    The path of the XML file to be generated.

    .EXAMPLE
    New-HashXML -directory "C:\Files" -xmlPath "C:\Hashes.xml"
    Generates an XML file "Hashes.xml" in the specified directory containing the SHA256 hash values of files in the "C:\Files" directory and its subdirectories.
    #>

    param(
        [Parameter(Mandatory=$true)]
        [string]$directory,

        [Parameter(Mandatory=$true)]
        [string]$xmlPath
    )

    # Erstellen des XmlDocument-Objekts
    $xmlDoc = New-Object System.Xml.XmlDocument -Verbose

    # Erstellen des Root-Elements
    $root = $xmlDoc.CreateElement("HashValues")
    $xmlDoc.AppendChild($root)

    # Durchsuchen der Dateien im Verzeichnis
    $files = Get-ChildItem -Path $directory -File -Recurse -Verbose
    foreach ($file in $files) 
    {
        # Erstellen des <file> Elements
        $fileElement = $xmlDoc.CreateElement("File")

        # Erstellen des <name> Elements innerhalb des <file> Elements
        $nameElement = $xmlDoc.CreateElement("Name")
        $nameElement.InnerText = $file.Name
        $fileElement.AppendChild($nameElement)

        # Hash-Wert der Datei abrufen
        $fileHash = Get-FileHash -Path $file.FullName -Algorithm SHA256 -Verbose

        # Erstellen des <hash> Elements innerhalb des <file> Elements
        $hashElement = $xmlDoc.CreateElement("Hash")
        $fileElement.AppendChild($hashElement)

        # Erstellen des <algorithm> Elements innerhalb des <hash> Elements
        $algorithmElement = $xmlDoc.CreateElement("Algorithm")
        $algorithmElement.InnerText = $fileHash.Algorithm
        $hashElement.AppendChild($algorithmElement)

        # Erstellen des <value> Elements innerhalb des <hash> Elements
        $valueElement = $xmlDoc.CreateElement("Value")
        $valueElement.InnerText = $fileHash.Hash
        $hashElement.AppendChild($valueElement)

        $root.AppendChild($fileElement)
    }

    # Speichern des XML-Dokuments
        $xmlDoc.Save("$xmlPath")
}