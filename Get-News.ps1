<#
.SYNOPSIS
    Reads news from select locations.
    
.DESCRIPTION
    The cmdlet will dump RSS news feeds to the screen.

.EXAMPLE
    Get-News -type IT
#>

Param(
        [Parameter(Mandatory=$true,
        HelpMessage="Type of news to pull. Options are IT, US, World, Games, Fun, or Portland.")]
        [ValidateSet("IT", "US", "World", "Games", "Fun", "Portland")]
        [string] $Type = "US",

        [Parameter(Mandatory=$false)]
        [array] $BlockList
)

$World =    "https://www.npr.org/rss/rss.php?id=1004",
            "https://feeds.a.dj.com/rss/RSSWorldNews.xml",
            "https://www.theguardian.com/world/rss"

$Fun =  "https://www.goodnewsnetwork.org/category/news/feed/",
        "https://www.newyorker.com/feed/rss",
        "http://news.mit.edu/rss/feed",
        "https://feeds.content.dowjones.io/public/rss/RSSLifestyle",
        "https://feeds.content.dowjones.io/public/rss/socialhealth",
        "https://feeds.content.dowjones.io/public/rss/RSSArtsCulture"

$US =   "https://www.npr.org/rss/rss.php?id=1003",
        "https://feeds.content.dowjones.io/public/rss/RSSUSnews"

$Portland = "https://www.koin.com/feed",
            "https://www.kgw.com/feeds/syndication/rss/news"

$ITNews =   "https://news.ycombinator.com/rss",
            "https://www.bleepingcomputer.com/feed/",
            "https://www.techdirt.com/feed/",
            "https://hackspace.raspberrypi.org/feed/"

$Game = "https://www.gamespot.com/feeds/news/",
        "https://www.wowhead.com/news/rss/retail"

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
    $Stories = $Stories | Select-Object -First 3
    $Stories
}

$Sources = switch ($Type) {
    IT          {$ITNews}
    Games       {$Game}
    US          {$US}
    World       {$World}
    Fun         {$Fun}
    Portland    {$Portland}
}

$TypeColor = switch ($Type) {
    IT          {'Green'}
    Games       {'Yellow'}
    US          {'Red'}
    World       {'Cyan'}
    Fun         {'Magenta'}
    Portland    {'Gray'}
}

ForEach ($Feed in $Sources) {
    $RawFeed = Invoke-WebRequest $Feed
    $AllStories += PullNews($RawFeed)
}

$AllStories = $AllStories | Sort-Object -Property pubdate -Descending

if ($Blocklist) {
    foreach ($Block in $BlockList.Split(",")) {
       # Write-Host "Blocking stories with: $Block" -ForegroundColor Red
        $AllStories = $AllStories | Where-Object { $_.title -notlike "*$Block*" }
    }
}

$AllStories | ForEach-Object {
    Write-Host "-----------------------------"
    Write-Host "$($_.FeedTitle) " -ForegroundColor $TypeColor -NoNewline
    Write-Host "$($_.pubdate)" -ForegroundColor Yellow
    Write-Host "$($_.title)"
    Write-Host "$($_.link)"
    Write-Host ""
}