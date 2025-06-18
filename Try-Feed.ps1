<#
.SYNOPSIS
    Attempt to get news from a specific feed and display to screen.
    
.DESCRIPTION
    The cmdlet will dump RSS news feeds to the screen.

.EXAMPLE
    Get-News -Feed "https://www.npr.org/rss/rss.php?id=1003"
#>

Param(
        [Parameter(Mandatory=$true)]
        [string] $Feed
)

function PullNews($Feed) {
    [xml]$FeedXml = $Feed.Content
    $Stories = @()
    $Items = $feedxml.rss.channel.item
    $FeedTitle = $feedxml.rss.channel.title
        ForEach ($Item in $Items) {
                $Story = New-Object psobject
                $Story | Add-Member Title $Item.Title
                $Story | Add-Member FeedTitle $FeedTitle
                $Story | Add-Member Link $Item.Link
                $PubDate = $Item.PubDate | Get-Date -ErrorAction SilentlyContinue
                $Story | Add-Member pubdate $pubdate
                $Stories += $Story
        }
    $Stories = $Stories | Sort-Object pubdate -Descending | Select-Object -First 1
    $Stories
}

$RawFeed = Invoke-WebRequest $Feed
$AllStories += PullNews($RawFeed)

$AllStories = $AllStories | Sort-Object -Property pubdate -Descending

$AllStories | ForEach-Object {
    Write-Host "-----------------------------"
    Write-Host "$($_.FeedTitle) " -ForegroundColor Green -NoNewline
    Write-Host "$($_.pubdate)" -ForegroundColor Yellow
    Write-Host "$($_.title)"
    Write-Host "$($_.link)"
    Write-Host ""
}