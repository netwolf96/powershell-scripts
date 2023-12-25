function New-R2Burn {
    <#
    .SYNOPSIS
    This cmdlet executes a REST request to extract a URL value from a response.

    .DESCRIPTION
    This function accepts text, URI and proxy information as parameters, sends a POST request to the specified URI with the text as secret and then extracts the URL value from the response.

    .PARAMETER text
    The text that is used as the secret in the POST request.

    .PARAMETER uri
    The URI to which the POST request is sent.

    .EXAMPLE
    New-R2Burn -text "Geheim" -uri "https://example.com/api"
    #>

		param (
			[string]$secret,
			[string]$uri
		)

		# Body and URL
		$body = @{
			secret = $secret
		}
		
		$url = "$uri"

		try {
			# REST-POST-Request
			$response = Invoke-RestMethod -Uri $url -Method Post -Body $body

			# RegEx to extract URL
			$regex = 'value="([^"]+)"'
			$match = [Regex]::Match($response, $regex)

			# Check Output
			if ($match.Success) 
			{
				$urlValue = $match.Groups[1].Value
				return $urlValue
			} 
			
			else 
			{
				throw "No Match for URL."
			}
		} 
		
		catch 
		{
			throw "Error at Requests: $_"
		}
}

Export-ModuleMember -Function New-R2Burn