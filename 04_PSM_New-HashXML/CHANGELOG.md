## Changelog for "New-HashXML" PowerShell Module

### Version 1.0.0 - Released on 02.10.2023

#### Added
- Initial implementation of the "New-HashXML" PowerShell module for generating an XML file containing the hash values (SHA256) of files in a given directory.

#### Features
- Added the `New-HashXML` function, which takes two mandatory parameters: `directory` and `xmlPath`.
- The `New-HashXML` function recursively scans the specified directory and creates an XML file that includes file names and their corresponding SHA256 hash values.
- The XML file structure includes `<HashValues>` as the root element, `<File>` elements for each file, `<Name>` elements for file names, and `<Hash>` elements for hash values with `<Algorithm>` and `<Value>` sub-elements.
- Utilizes the `Get-FileHash` cmdlet to calculate SHA256 hash values for files.
- Provides a clear and concise synopsis, description, and example in the function's documentation.

#### Usage
```powershell
# Generate an XML file containing SHA256 hash values of files in a directory
New-HashXML -directory "C:\Files" -xmlPath "C:\Hashes.xml"
```

This PowerShell module is designed to simplify the process of generating hash values for files in a directory and storing them in an XML file. It can be a valuable tool for data integrity verification and digital forensics.