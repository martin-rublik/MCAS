function Get-MCASPolicy {
    [CmdletBinding()]
    param
    (
        # Fetches a policy by its unique identifier.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [Alias("_id")]
        [string]$Identity,

        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )
    begin {}
    process
    {
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        if ($Identity)
        {
            try {
                # Fetch the item by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/policies/$Identity/disable/" -Method Post
            }
            catch {
                throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
            }

            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
            }
            catch {}
            
            $response
        }
    }
    end{}
}