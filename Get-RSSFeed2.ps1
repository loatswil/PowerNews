# Get-Feed2
# Used to get an RSS feed and output to screen
#

<#
.SYNOPSIS
    Display a supplied RSS feeds in readable format.
    
.DESCRIPTION
    The cmdlet accepts one input URI, which will be read
    and parsed and output to the screen.

.PARAMETER Feed
    RSS Feed to be read.

.EXAMPLE
    Get-News -Feed http://examplefeed.com/rss
#>

[CmdletBinding()]

Param(
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ValidateNotNullOrEmptyAttribute()]
        [string] $RSSFeed
)

$rawfeed = Invoke-WebRequest $RSSFeed

function PullNews2($feed) {
    [xml]$feedxml = $feed.Content
    $stories = @()
    $items = $feedxml.rss.channel.item
    $feedtitle = $feedxml.rss.channel.title
        ForEach ($item in $items) {
            $title = $item.title
            $link = $item.link
            $pubdate = $item.pubdate
            $pubdate = $pubdate | Get-Date -ErrorAction SilentlyContinue
            $desc = $item.description
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate;desc=$desc;feedtitle=$feedtitle}
            $stories += $story
        }
    #$stories = $stories | Sort-Object pubdate -Descending | Select-Object -First 3 | Sort-Object -Property pubdate -Descending
    $stories
}

PullNews2($rawfeed)