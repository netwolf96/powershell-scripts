## Changelog for "Compare-Hashes" PowerShell Function

### Version 1.0.0 - Released on 02.10.2023

#### Added
- Initial implementation of the "Compare-Hashes" PowerShell function for comparing hash values of files in a specified folder with hash values in an XML file.
- Function includes the following features:
  - Compares hash values of files in a specified folder with those in an XML file.
  - Provides clear documentation with a synopsis, description, and example.
  - Displays results indicating whether all hash values are identical or if there are differences.
  - Lists files with different hashes and missing/added files when differences exist.

#### Usage
```powershell
# Compare hash values of files in a folder with those in an XML file
Compare-Hashes -folderPath "C:\FolderPath\" -hashesXMLPath "C:\HashXMLPath\HashXML.xml"
```