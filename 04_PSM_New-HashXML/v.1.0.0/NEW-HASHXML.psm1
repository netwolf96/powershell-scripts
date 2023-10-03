function NEW-HASHXML 
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
    NEW-HASHXML -directory "C:\Files" -xmlPath "C:\Hashes.xml"
    Generates an XML file "Hashes.xml" in the specified directory containing the SHA256 hash values of files in the "C:\Files" directory and its subdirectories.
    #>

    param(
        [Parameter(Mandatory=$true)]
        [string]$directory,

        [Parameter(Mandatory=$true)]
        [string]$xmlPath
    )

    # Create the XmlDocument object
    $xmlDoc = New-Object System.Xml.XmlDocument -Verbose

    # Create the root element
    $root = $xmlDoc.CreateElement("HashValues")
    $xmlDoc.AppendChild($root)

    # Browse the files in the directory
    $files = Get-ChildItem -Path $directory -File -Recurse -Verbose
    foreach ($file in $files) 
    {
        # Creating the <file> element
        $fileElement = $xmlDoc.CreateElement("File")

        # create the <name> element inside the <file> element
        $nameElement = $xmlDoc.CreateElement("Name")
        $nameElement.InnerText = $file.Name
        $fileElement.AppendChild($nameElement)

        # Retrieve hash value of the file
        $fileHash = Get-FileHash -Path $file.FullName -Algorithm SHA256 -Verbose

        # create the <hash> element inside the <file> element
        $hashElement = $xmlDoc.CreateElement("Hash")
        $fileElement.AppendChild($hashElement)

        # create the <algorithm> element inside the <hash> element
        $algorithmElement = $xmlDoc.CreateElement("Algorithm")
        $algorithmElement.InnerText = $fileHash.Algorithm
        $hashElement.AppendChild($algorithmElement)

        # create the <value> element inside the <hash> element
        $valueElement = $xmlDoc.CreateElement("Value")
        $valueElement.InnerText = $fileHash.Hash
        $hashElement.AppendChild($valueElement)

        $root.AppendChild($fileElement)
    }

    # Save the XML document
        $xmlDoc.Save("$xmlPath")
}