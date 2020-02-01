<#  Parse-Feed
    This script will pull a feed and show all the available 
    parts that may be readable to incorporate into the 
    Get-News script

    .SYNOPSIS
        Reads a web feed using Invoke-WebReuest
        and shows usable output.

    .DESCRIPTION
        This cmdlet will accept input in the form of a 
        URL and parse that feed into reaable output
        for incorporation into the Get-News RSS reader.

    .EXAMPLE
        Parse-Feed https://www.random-feed.org/news.rss


    #>

[CmdletBinding()]

Param(
        [Parameter(Mandatory=$true)]
        [string] $feed
)

#$rawfeed = @()

$rawfeed = Invoke-WebRequest $feed

$rawfeed | Get-Member

Write-Output ""

$rawfeed 

# ForEach ($member in $members) {
#     if ($member.MemberType -like "Property") {
#         $member.Name
#         $member.Definition
#         Write-Output ""
#     }
# }