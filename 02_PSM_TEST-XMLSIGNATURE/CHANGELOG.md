## Changelog for "TEST-XMLSIGNATURE" Function

### Version 1.0.0 - Released on [27.07.2023]

#### Added
- Initial implementation of the "TEST-XMLSIGNATURE" function for verifying digital signatures in an XML file using a specified certificate's public key.

#### Features
- The function takes two parameters: "XmlFilePath" and "CertificateSubjectName," which specify the path of the XML file containing the digital signatures to be verified and the subject name (common name) of the X.509 certificate used for signature validation, respectively.
- Loads the required .NET classes from the System.Security namespace for XML signature validation.
- Searches for "Signature" elements in the XML file and validates each signature using the specified certificate's public key.
- Displays a success message if the signatures are valid.
- Indicates whether the signature is invalid or encounters any errors during the verification process.

#### Usage
```sh
TEST-XMLSIGNATURE -XmlFilePath "C:\path\to\example.xml" -CertificateSubjectName "CN=ExampleCertificate"
```

This example runs the function to verify digital signatures in the XML file located at "C:\path\to\example.xml". It uses the X.509 certificate with the subject name "CN=ExampleCertificate" for signature validation.

#### Notes
- This function requires the .NET classes from the System.Security namespace for verifying digital signatures in the XML file.
- The script is provided "as-is" without any warranties or guarantees. Use at your own risk.