# XML Signing and Verification Functions

This repository contains PowerShell functions for signing and verifying XML files using X.509 certificates. The functions enable you to add digital signatures to XML documents for data integrity and authenticity verification.

## Contents

1. [Introduction](#introduction)
2. [Functions](#functions)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Requirements](#requirements)
6. [Notes](#notes)
7. [License](#license)

## Introduction

The XML signing and verification functions in this repository offer an easy and secure way to sign XML files using a user certificate and verify existing signatures in XML documents. The functions are implemented in PowerShell and utilize the .NET classes from the System.Security and System.Xml namespaces for XML signing and verification.

## Functions

### `NEW-SIGNEDXML`

The `NEW-SIGNEDXML` function allows you to sign an XML file using a specified certificate. It takes the following parameters:

- `XmlFilePath`: Specifies the path to the XML file that needs to be signed.
- `CertificateSubjectName`: Specifies the subject name (common name) of the X.509 certificate to be used for signing.

### `TEST-XMLSIGNATURE`

The `TEST-XMLSIGNATURE` function verifies digital signatures in an XML file using the X.509 certificate's public key. It takes the following parameters:

- `XmlFilePath`: Specifies the path of the XML file containing the digital signatures to be verified.
- `CertificateSubjectName`: Specifies the subject name (common name) of the X.509 certificate used for signature validation.

### `New-HashXML`

#### Synopsis

Generates an XML file containing the hash values (SHA256) of files in a given directory.

#### Description

This function recursively scans a directory and creates an XML file that includes the file names and their corresponding SHA256 hash values.

#### Parameters

- `directory`: The directory path where the files are located.
- `xmlPath`: The path of the XML file to be generated.

### Removing Duplicate Certificates

The provided script removes duplicate certificates from the specified certificate store (`Root` in this case).

## Installation

1. Clone or download this repository to your local machine.

## Usage

1. Open a PowerShell session.

2. Import the functions into your PowerShell session using the `Import-Module` cmdlet.

3. Use the `NEW-SIGNEDXML` function to sign an XML file and the `TEST-XMLSIGNATURE` function to verify digital signatures in an XML file.

```powershell
# Signing an XML file
NEW-SIGNEDXML -XmlFilePath "C:\path\to\example.xml" -CertificateSubjectName "CN=ExampleCertificate"

# Verifying signatures in an XML file
TEST-XMLSIGNATURE -XmlFilePath "C:\path\to\example.xml" -CertificateSubjectName "CN=ExampleCertificate"
```

4. Use the `New-HashXML` function to generate an XML file containing the hash values of files in a directory.

```powershell
# Generate an XML file containing hash values of files in a directory
New-HashXML -directory "C:\path\to\files" -xmlPath "C:\path\to\hashes.xml"
```

## Requirements

- PowerShell 5.1 or later.
- .NET classes from the System.Security and System.Xml namespaces.

## Notes

- This software is provided "as-is" without any warranties or guarantees. Use at your own risk.
- The functions require appropriate permissions to access certificates and XML files on the system.

## License

Copyright © 2023 netzack-it. All rights reserved. This script is provided "as-is" without any warranties or guarantees. Use at your own risk.