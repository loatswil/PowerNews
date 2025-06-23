<#
    .SYNOPSIS
        Attemps to find an RSS feed from a given URL.
    .DESCRIPTION
        The cmdlet will attempt to find an RSS feed from a given URL.
    .EXAMPLE
        Find-Feed -Url "https://www.npr.org/
    .PARAMETER Url
        The URL to search for an RSS feed.

#>

Param(
    [Parameter(Mandatory=$true)]
    [string] $Url
)

function Find-Feed {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Url
    )

    try {
        $response = Invoke-WebRequest -Uri $Url -ErrorAction Stop
        $links = $response.Content | findstr.exe 'application/rss+xml'
        #$links = $response.Content | Where-Object { $_.rel -eq 'alternate' -and $_.type -eq 'application/rss+xml' }
        
        if ($links) {
            return $links
        } else {
            Write-Host "No RSS feed found at the specified URL." -ForegroundColor Yellow
            return $null
        }
    } catch {
        Write-Host "Error fetching URL: $_" -ForegroundColor Red
        return $null
    }
}