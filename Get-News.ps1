<#
.SYNOPSIS
    Reads news from select locations.
    
.DESCRIPTION
    The cmdlet will dump RSS news feeds to the screen. 
    IT, World, US, Fun, Games, Apple, Microsoft, Movies, Portland

.EXAMPLE
    Get-News -type IT
#>

Param(
        [Parameter(Mandatory,
        HelpMessage = "Enter a type of news such as: IT, World, US, Fun, Games, Apple, Microsoft, Movies, Portland, etc.")]
        [array] $Types,

        [Parameter(Mandatory=$false)]
        [array] $BlockList,

        [Parameter(Mandatory=$false)]
        [switch] $Today
)

$Sources = Import-csv ./RSSFeeds.csv

function PullNews($Feed) {
    [xml]$FeedXml = $Feed.Content
    $Stories = @()
    if ($FeedXml.rss.channel.title."#cdata-section") {
        $FeedTitle = $FeedXml.rss.channel.title."#cdata-section"
    } else {
        $FeedTitle = $feedxml.rss.channel.title
    }
    $Items = $feedxml.rss.channel.item
        ForEach ($Item in $Items) {
            $Story = New-Object psobject
            if($item.title."#cdata-section") {
                $Story | Add-Member title $item.title."#cdata-section"
            } else {
                $Story | Add-Member title $item.title
            }
            $Story | Add-Member FeedTitle $FeedTitle
            $Story | Add-Member link $item.link
            $pubdate = $item.pubdate | Get-Date -ErrorAction SilentlyContinue
            $Story | Add-Member pubdate $pubdate
            $Stories += $Story
        }
    $Stories = $Stories | Sort-Object pubdate -Descending | Select-Object -First 3
    $Stories
}

ForEach ($Type in $Types) {
    ForEach ($Feed in $Sources | Where-Object {$_.type -eq $Type} ) { 
        $RawFeed = Invoke-WebRequest $Feed.url
        $AllStories += PullNews($RawFeed)
    }
}

if ($Blocklist) {
    foreach ($Block in $BlockList.Split(",")) {
       # Write-Host "Blocking stories with: $Block" -ForegroundColor Red
        $AllStories = $AllStories | Where-Object { $_.title -notlike "*$Block*" }
    }
}

if ($Today) {
    $AllStories = $AllStories | Where-Object { $_.pubdate.DayOfYear -eq (Get-Date).DayOfYear}
}

$AllStories = $AllStories | Sort-Object -Property pubdate -Descending

Clear-Host

$AllStories | ForEach-Object {
    Write-Host "-----------------------------"
    Write-Host "$($_.FeedTitle) " -ForegroundColor Green -NoNewline
    Write-Host "$($_.pubdate)" -ForegroundColor Yellow
    Write-Host "$($_.title)"
    Write-Host "$($_.link)"
    Write-Host ""
}
