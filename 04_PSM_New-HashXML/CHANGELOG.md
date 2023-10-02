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

#### XML File Structure
```xml
<HashValues>
    <File>
        <Name>file1.txt</Name>
        <Hash>
            <Algorithm>SHA256</Algorithm>
            <Value>3F1B6FEEA02C1B175D0E9EB61F9F2C50A50EAEA06BC0D57737C4C1E12D6011C2</Value>
        </Hash>
    </File>
    <File>
        <Name>file2.docx</Name>
        <Hash>
            <Algorithm>SHA256</Algorithm>
            <Value>59B32F8ECD8E06BB393A49FA3F251D3D7E6A4C5E1685E1C62F6E70322B892EE1</Value>
        </Hash>
    </File>
    <!-- More files and hash entries go here -->
</HashValues>
```

#### Usage
```powershell
# Generate an XML file containing SHA256 hash values of files in a directory
New-HashXML -directory "C:\Files" -xmlPath "C:\Hashes.xml"
```

This PowerShell module is designed to simplify the process of generating hash values for files in a directory and storing them in an XML file. It can be a valuable tool for data integrity verification and digital forensics.