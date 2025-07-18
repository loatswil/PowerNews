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
        [string] $Days
)

#$Sources = Import-csv ./RSSFeeds.csv

# Create an array of custom objects
$Sources = @(
    [PSCustomObject]@{ type = "IT"; url = "https://news.ycombinator.com/rss" },
    [PSCustomObject]@{ type = "IT"; url = "https://www.techdirt.com/feed/" },
    [PSCustomObject]@{ type = "Fun"; url = "https://hackspace.raspberrypi.org/feed" },
    [PSCustomObject]@{ type = "IT"; url = "https://www.bleepingcomputer.com/feed/" },
    [PSCustomObject]@{ type = "Microsoft"; url = "https://www.microsoft.com/en-us/microsoft-365/blog/feed/" },
    [PSCustomObject]@{ type = "Microsoft"; url = "https://azure.microsoft.com/en-us/blog/feed/" },
    [PSCustomObject]@{ type = "Microsoft"; url = "https://rssfeed.azure.status.microsoft/en-us/status/feed/" },
    [PSCustomObject]@{ type = "Apple"; url = "https://www.appleinsider.com/appleinsider.rss" },
    [PSCustomObject]@{ type = "Apple"; url = "https://feeds.macrumors.com/MacRumors-All" },
    [PSCustomObject]@{ type = "Movies"; url = "https://variety.com/v/film/feed" },
#    [PSCustomObject]@{ type = "Movies"; url = "https://www.themix.net/feed/" },
    [PSCustomObject]@{ type = "Fun"; url = "http://news.mit.edu/rss/feed" },
    [PSCustomObject]@{ type = "Fun"; url = "http://www.menshealth.com/events-promotions/washpofeed" },
    [PSCustomObject]@{ type = "Fun"; url = "https://feeds.content.dowjones.io/public/rss/RSSLifestyle" },
    [PSCustomObject]@{ type = "Fun"; url = "https://feeds.content.dowjones.io/public/rss/socialhealth" },
    [PSCustomObject]@{ type = "Fun"; url = "https://feeds.content.dowjones.io/public/rss/RSSArtsCulture" },
    [PSCustomObject]@{ type = "World"; url = "https://www.npr.org/rss/rss.php?id=1004" },
    [PSCustomObject]@{ type = "World"; url = "https://feeds.a.dj.com/rss/RSSWorldNews.xml" },
    [PSCustomObject]@{ type = "World"; url = "https://www.theguardian.com/world/rss" },
    [PSCustomObject]@{ type = "World"; url = "https://www.rawstory.com/feeds/feed.rss" },
    [PSCustomObject]@{ type = "US"; url = "https://www.npr.org/rss/rss.php?id=1003" },
    [PSCustomObject]@{ type = "US"; url = "https://feeds.content.dowjones.io/public/rss/RSSUSnews" },
    [PSCustomObject]@{ type = "US"; url = "https://www.rawstory.com/feeds/us-news.rss" },
    [PSCustomObject]@{ type = "Games"; url = "https://www.wowhead.com/news/rss/retail" },
    [PSCustomObject]@{ type = "Games"; url = "https://www.wowhead.com/news/rss/other-blizzard-games" },
    [PSCustomObject]@{ type = "Games"; url = "https://www.gamespot.com/feeds/news/" },
    [PSCustomObject]@{ type = "Games"; url = "https://www.videogameschronicle.com/category/news/feed/" },
    [PSCustomObject]@{ type = "Games"; url = "https://www.seattletimes.com/video-games/feed/" },
    [PSCustomObject]@{ type = "Portland"; url = "https://www.koin.com/feed" },
    [PSCustomObject]@{ type = "Portland"; url = "https://www.kgw.com/feeds/syndication/rss/news" },
    [PSCustomObject]@{ type = "World"; url = "https://rss.nytimes.com/services/xml/rss/nyt/World.xml" },
    [PSCustomObject]@{ type = "US"; url = "https://rss.nytimes.com/services/xml/rss/nyt/US.xml" },
    [PSCustomObject]@{ type = "IT"; url = "https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml" },
    [PSCustomObject]@{ type = "US"; url = "https://www.seattletimes.com/nation/feed/" },
    [PSCustomObject]@{ type = "World"; url = "https://www.seattletimes.com/world/feed/" },
    [PSCustomObject]@{ type = "Movies"; url = "https://www.seattletimes.com/movies/feed/" },
    [PSCustomObject]@{ type = "IT"; url = "https://www.seattletimes.com/technology/feed/" }
    )
 
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

if ($Days) {
    $AllStories = $AllStories | Where-Object { $_.pubdate.DayOfYear -ge (Get-Date).AddDays(-$Days).DayOfYear }
    $doy = (Get-Date).AddDays(-$Days).DayOfYear
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
