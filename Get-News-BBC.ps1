# Get-News-BBC
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
    Get-News-BBC -ShowOutput
#>

[CmdletBinding()]

Param(
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.ValidateNotNullOrEmptyAttribute()]
        [switch]
        $ShowOutput
)

Function GetTechNews {
    $rawtech = Invoke-WebRequest http://feeds.bbci.co.uk/news/technology/rss.xml
    [xml]$newstech = $rawtech.Content
    $titles = $newstech.rss.channel.Item
    foreach($story in $titles) {
        Write-Output "<a href="""
        $story.link
        Write-Output """>"
        $story.title."#cdata-section"
        Write-Output "</a><br>"
    }
}
Function GetUSNews {
    $rawus = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml
    [xml]$newsus = $rawus.Content
    $titles = $newsus.rss.channel.Item
    foreach($story in $titles) {
        Write-Output "<a href="""
        $story.link
        Write-Output """>"
        $story.title."#cdata-section"
        Write-Output "</a><br>"
    }
}
Function GetWorldNews {
    $rawworld = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/rss.xml
    [xml]$newsworld = $rawworld.Content
    $titles = $newsworld.rss.channel.Item
    foreach($story in $titles) {
        Write-Output "<a href="""
        $story.link
        Write-Output """>"
        $story.title."#cdata-section"
        Write-Output "</a><br>"
    }
}
Function ShowWorldNews {
    $rawworld = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/rss.xml
    [xml]$newsworld = $rawworld.Content
    $titles = $newsworld.rss.channel.Item
    foreach($story in $titles) {
        $story.title."#cdata-section"
        $story.link
    }
}
Function ShowUSNews {
    $rawus = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml
    [xml]$newsus = $rawus.Content
    $titles = $newsus.rss.channel.Item
    foreach($story in $titles) {
        $story.title."#cdata-section"
        $story.link
    }
}
Function ShowTechNews {
    $rawtech = Invoke-WebRequest http://feeds.bbci.co.uk/news/technology/rss.xml
    [xml]$newstech = $rawtech.Content
    $titles = $newstech.rss.channel.Item
    foreach($story in $titles) {
        $story.title."#cdata-section"
        $story.link
    }
}
function WriteFile {
    Add-Content -Value (Write-Output "<b>BBC News - </b>") -Path $Output
    Add-Content -Value (Get-date) -Path $Output
    Add-Content -Value ("<br>") -Path $Output
    Add-Content -Value (Write-Output "<b><br>BBC World News<br></b>") -Path $Output
    Add-Content -Value(GetWorldNews) -Path $Output
    Add-Content -Value (Write-Output "<b><br>BBC US News<br></b>") -Path $Output
    Add-Content -Value(GetUSNews) -Path $Output
    Add-Content -Value (Write-Output "<b><br>BBC Tech News<br></b>") -Path $Output
    Add-Content -Value(GetTechNews) -Path $Output
}
function WriteHost {
    Write-Host "BBC News"(Get-Date)
    Write-Host "`nBBC World News"
    ShowWorldNews
    Write-Host "`nBBC US News"
    ShowUSNews
    Write-Host "`nBBC Tech News"
    ShowTechNews
}

if($ShowOutput) {
    WriteHost
    Exit
}
else {
    $Output = "~/Desktop/News-BBC.html"
    if (Test-Path $Output) {
        Clear-Content $Output
        }
        else {
            New-Item -Path $Output -ItemType File -Confirm
        }
    WriteFile
}