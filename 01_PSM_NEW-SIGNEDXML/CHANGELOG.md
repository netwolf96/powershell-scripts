## Changelog for "NEW-SIGNEDXML" Function

### Version 1.0.0 - Released on [25.07.2023]

#### Added
- Initial implementation of the "NEW-SIGNEDXML" function for signing XML files using a user certificate.

#### Features
- The function takes two parameters: "xmlFilePath" and "certificateCommonName," which specify the path to the XML file to be signed and the common name (CN) of the certificate used for signing, respectively.
- Searches for the specified certificate in the user certificate store based on the provided common name.
- Loads the required .NET classes from the System.Security namespace for XML signing.
- Creates a SignedXml object and adds the certificate to it for signing.
- Creates a reference to the entire XML file and adds the hash algorithm (SHA-256) to the reference.
- Computes the XML signature and adds it to the XML document.
- Saves the signed XML to a new file with "_signed" appended to the original file name.

#### Usage
```sh
NEW-SIGNEDXML -xmlFilePath "C:\Files\Document.xml" -certificateCommonName "MyCertificate"
```

Signs the XML file "C:\Files\Document.xml" using the certificate with the common name "MyCertificate" and saves the signed XML to "C:\Files\Document_signed.xml".

#### Notes
- This function requires the .NET classes from the System.Security namespace for signing the XML using a certificate.
- The script is provided "as-is" without any warranties or guarantees. Use at your own risk.