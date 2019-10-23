# Get-News-Reuters
# Used to get the news from various sources and writes the output
# to the users desktop or to the screen.

<#
.SYNOPSIS
    Display news from various news locations.
    
.DESCRIPTION
    The cmdlet accepts one input switch, which will cause the output 
    to be displayed to the screen vs. written to a file.

.PARAMETER ShowOutput
    Displays the output to the screen.

.EXAMPLE
    Get-News-Reuters -ShowOutput
#>

[CmdletBinding()]

Param(
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.ValidateNotNullOrEmptyAttribute()]
        [switch]
        $ShowOutput
)
function GetTechNews {
    $rawtech = Invoke-WebRequest http://feeds.reuters.com/reuters/technologyNews
    [xml]$newstech = $rawtech.Content
    $titles = $newstech.rss.channel.Item
    foreach($story in $titles) {
        Write-Output "<a href="""
        $story.link
        Write-Output """>"
        $story.title
        Write-Output "</a><br>"
    }
}
function GetUSNews {
    $rawus = Invoke-WebRequest http://feeds.reuters.com/Reuters/domesticNews
    [xml]$newsus = $rawus.Content
    $titles = $newsus.rss.channel.Item
    foreach($story in $titles) {
        Write-Output "<a href="""
        $story.link
        Write-Output """>"
        $story.title
        Write-Output "</a><br>"
    }
}
function GetWorldNews {
    $rawworld = Invoke-WebRequest http://feeds.reuters.com/Reuters/worldNews
    [xml]$newsworld = $rawworld.Content
    $titles = $newsworld.rss.channel.Item
    foreach($story in $titles) {
        Write-Output "<a href="""
        $story.link
        Write-Output """>"
        $story.title
        Write-Output "</a><br>"
    }
}
function ShowTechNews {
    $rawtech = Invoke-WebRequest http://feeds.reuters.com/reuters/technologyNews
    [xml]$newstech = $rawtech.Content
    $titles = $newstech.rss.channel.Item
    foreach($story in $titles) {
        $story.title
        $story.link
    }
}
function ShowUSNews {
    $rawus = Invoke-WebRequest http://feeds.reuters.com/Reuters/domesticNews
    [xml]$newsus = $rawus.Content
    $titles = $newsus.rss.channel.Item
    foreach($story in $titles) {
        $story.title
        $story.link
    }
}
function ShowWorldNews {
    $rawworld = Invoke-WebRequest http://feeds.reuters.com/Reuters/worldNews
    [xml]$newsworld = $rawworld.Content
    $titles = $newsworld.rss.channel.Item
    foreach($story in $titles) {
        $story.title
        $story.link
    }    
}
function WriteFile {
    Add-Content -Value (Write-Output "<b>Reuters News - </b>") -Path $Output
    Add-Content -Value (Get-date) -Path $Output
    Add-Content -Value ("<br>") -Path $Output
    Add-Content -Value (Write-Output "<b><br>Reuters World News<br></b>") -Path $Output
    Add-Content -Value(GetWorldNews) -Path $Output
    Add-Content -Value (Write-Output "<b><br>Reuters US News<br></b>") -Path $Output
    Add-Content -Value(GetUSNews) -Path $Output
    Add-Content -Value (Write-Output "<b><br>Reuters Tech News<br></b>") -Path $Output
    Add-Content -Value(GetTechNews) -Path $Output
}
function WriteHost {
    Write-Host "Reuters News"(Get-Date)
    Write-Host "`nReuters World News"
    ShowWorldNews
    Write-Host "`nReuters US News"
    ShowUSNews
    Write-Host "`nReuters Tech News"
    ShowTechNews
}

if($ShowOutput) {
    WriteHost
    Exit
}
else {
    $Output = "~/Desktop/News-Reuters.html"
    if (Test-Path $Output) {
        Clear-Content $Output
        }
        else {
            New-Item -Path $Output -ItemType File -Confirm
        }
    WriteFile
}