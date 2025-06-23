<#
.SYNOPSIS
    Reads news from Slashdot.
    
.DESCRIPTION
    The cmdlet will dump RSS news feeds to the screen.

.EXAMPLE
    Get-Slashdot
#>

Param(
        [Parameter(Mandatory=$false)]
        [array] $BlockList
)

$Sources =  "http://rss.slashdot.org/Slashdot/slashdotMain",
            "http://rss.slashdot.org/Slashdot/slashdotGames",
            "http://rss.slashdot.org/Slashdot/slashdotHardware"
function PullNews($Feed) {
    [xml]$FeedXml = $Feed.Content
    $Stories = @()
    $FeedTitle = $feedxml.rdf.channel.title
    $Items = $feedxml.rdf.item
        ForEach ($Item in $Items) {
            $Story = New-Object psobject
            $Story | Add-Member title $item.title
            $Story | Add-Member FeedTitle $FeedTitle
            $Story | Add-Member link $item.link
            $pubdate = $item.date | Get-Date -ErrorAction SilentlyContinue
            $Story | Add-Member pubdate $pubdate
            $Story | Add-Member section $item.section
            $Stories += $Story
        }
    $Stories = $Stories | Sort-Object pubdate -Descending | Select-Object -First 2
    $Stories
}

Foreach ($Feed in $Sources) {
    $RawFeed = Invoke-WebRequest $Feed
    $AllStories += PullNews($RawFeed)
}

if ($Blocklist) {
    foreach ($Block in $BlockList.Split(",")) {
       # Write-Host "Blocking stories with: $Block" -ForegroundColor Red
        $AllStories = $AllStories | Where-Object { $_.title -notlike "*$Block*" }
    }
}

$AllStories = $AllStories | Sort-Object -Property pubdate -Descending

$AllStories | ForEach-Object {
    Write-Host "-----------------------------"
    Write-Host "$($_.pubdate) " -ForegroundColor Yellow -NoNewline
    Write-Host "$($_.section)" -ForegroundColor Red
    Write-Host "$($_.title) " -ForegroundColor Green
    Write-Host "$($_.link)"
    Write-Host ""
}
