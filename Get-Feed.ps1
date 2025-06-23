<#
.SYNOPSIS
    Reads news from select locations.
    
.DESCRIPTION
    The cmdlet will dump RSS news feeds to the screen.

.EXAMPLE
    Get-News -Source https://www.rawstory.com/feeds/us-news.rss
#>

Param(
        [Parameter(Mandatory=$true)]
        [string] $Source,

        [Parameter(Mandatory=$false)]
        [array] $BlockList
)

function PullNews($Feed) {
    [xml]$FeedXml = $Feed.Content
    $Stories = @()
    $Items = $FeedXml.rss.channel.item
    $FeedTitle = $FeedXml.rss.channel.title
        ForEach ($Item in $Items) {
                $Story = New-Object psobject
                $Story | Add-Member title $item.title
                $Story | Add-Member feedtitle $feedtitle
                $Story | Add-Member link $item.link
                $pubdate = $item.pubdate | Get-Date -ErrorAction SilentlyContinue
                $Story | Add-Member pubdate $pubdate
                $Stories += $Story
        }
    $Stories = $Stories | Select-Object -First 5
    $Stories
}

ForEach ($Feed in $Source) {
    $RawFeed = Invoke-WebRequest $Feed
    $AllStories += PullNews($RawFeed)
}

$AllStories = $AllStories | Sort-Object -Property pubdate -Descending

if ($Blocklist) {
    foreach ($Block in $BlockList.Split(",")) {
        $AllStories = $AllStories | Where-Object { $_.title -notlike "*$Block*" }
    }
}

$AllStories | ForEach-Object {
    Write-Host "-----------------------------"
    Write-Host "$($_.FeedTitle) " -ForegroundColor Green -NoNewline
    Write-Host "$($_.pubdate)" -ForegroundColor Yellow
    Write-Host "$($_.title)"
    Write-Host "$($_.link)"
    Write-Host ""
}