# Get-News
# Used to get the news from various sources and writes the output
# to the users desktop in HTML readable format.

<#
.SYNOPSIS
    Reads news from select locations.
    
.DESCRIPTION
    The cmdlet will dump an HTML file to the users desktop with current news.

.EXAMPLE
    Get-News -ShowOutput

  
#>


<#  Simplifying for now 
    Will add back later for blacklisting

[CmdletBinding()]

Param(
        [Parameter(Mandatory=$false)]
        [switch] $ShowOutput,
        [Parameter(Mandatory=$false)]
        [switch] $Whitelist,
        [Parameter(Mandatory=$false)]
        [string] $Blacklist
)

#>

$allstories = @()
$Output = "~/Desktop/News.html"

$EconUS = Invoke-WebRequest https://www.economist.com/united-states/rss.xml
$EconWorld = Invoke-WebRequest https://www.economist.com/international/rss.xml
$EconTech = Invoke-WebRequest https://www.economist.com/science-and-technology/rss.xml
$Engadget = Invoke-WebRequest https://www.engadget.com/rss.xml
$GuadrianWorld = Invoke-WebRequest https://www.theguardian.com/world/rss
$CNNWorld = Invoke-WebRequest http://rss.cnn.com/rss/edition_world.rss
$YahooWorld = Invoke-WebRequest https://www.yahoo.com/news/world/rss
$AlJazeeraAll = Invoke-WebRequest http://www.aljazeera.com/xml/rss/all.xml
$BBCWorld = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/rss.xml
$BBCUS = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml
$BBCTech = Invoke-WebRequest http://feeds.bbci.co.uk/news/technology/rss.xml
$ReutersUS = Invoke-WebRequest http://feeds.reuters.com/Reuters/domesticNews
$ReutersWorld = Invoke-WebRequest http://feeds.reuters.com/Reuters/worldNews
$ReutersTech = Invoke-WebRequest http://feeds.reuters.com/reuters/technologyNews
$WSJWorld = Invoke-WebRequest https://feeds.a.dj.com/rss/RSSWorldNews.xml
$WSJTech = Invoke-WebRequest https://feeds.a.dj.com/rss/RSSWSJD.xml
$FA = Invoke-WebRequest https://www.foreignaffairs.com/rss.xml
$USAWorld = Invoke-WebRequest https://rssfeeds.usatoday.com/UsatodaycomWorld-TopStories
$USANational = Invoke-WebRequest https://rssfeeds.usatoday.com/UsatodaycomNation-TopStories
$USATech = Invoke-WebRequest https://rssfeeds.usatoday.com/usatoday-TechTopStories
$THEWEEK = Invoke-WebRequest https://theweek.com/rss.xml
$POCongress = Invoke-WebRequest http://www.politico.com/rss/congress.xml
$PODefense = Invoke-WebRequest http://www.politico.com/rss/defense.xml
$POEnergy = Invoke-WebRequest http://www.politico.com/rss/energy.xml

function PullNews1($feed) {
    [xml]$feedxml = $feed.Content
    $stories = @()
    $items = $feedxml.rss.channel.item
    $feedtitle = $feedxml.rss.channel.title
        ForEach ($item in $items) {
            $title = $item.title."#cdata-section"
            $link = $item.link
            $pubdate = $item.pubdate
            $pubdate = $pubdate | Get-Date -ErrorAction SilentlyContinue
            $desc = $item.description."#cdata-section"
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate;desc=$desc;feedtitle=$feedtitle}
            $stories += $story
        }
    $stories = $stories | Sort-Object pubdate -Descending | Select-Object -First 3 | Sort-Object -Property pubdate -Descending 
    $stories
}
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
    $stories = $stories | Sort-Object pubdate -Descending | Select-Object -First 3 | Sort-Object -Property pubdate -Descending
    $stories
}


$allstories += PullNews2($EconUS)
$allstories += PullNews2($EconWorld)
$allstories += PullNews2($EconTech)
$allstories += PullNews1($Engadget)
$allstories += PullNews1($CNNWorld)
$allstories += PullNews2($GuadrianWorld)
$allstories += PullNews2($YahooWorld)
$allstories += PullNews1($AlJazeeraAll)
$allstories += PullNews1($BBCWorld)
$allstories += PullNews1($BBCUS)
$allstories += PullNews1($BBCTech)
$allstories += PullNews2($ReutersUS)
$allstories += PullNews2($ReutersTech)
$allstories += PullNews2($ReutersWorld)
$allstories += PullNews1($THEWEEK)
$allstories += PullNews2($WSJWorld)
$allstories += PullNews2($WSJTech)
$allstories += PullNews2($USAWorld)
$allstories += PullNews2($USANational)
$allstories += PullNews2($USATech)
$allstories += PullNews2($FA)
$allstories += PullNews2($POCongress)
$allstories += PullNews2($PODefense)
$allstories += PullNews2($POEnergy)

$allstories = $allstories | Sort-Object -Property pubdate -Descending

function WriteFile() {
    Add-Content -Value (Write-Output "<b>News</b>") -Path $Output
    Add-Content -Value (Get-date) -Path $Output
    Add-Content -Value ("<br>") -Path $Output
    foreach($story in $allstories) {
        Add-Content -Value (Write-Output "<font size=""-1"">"$story.pubdate "</font>") -Path $Output       
        Add-Content -Value (Write-Output "&nbsp;") -Path $Output
        Add-Content -Value (Write-Output "<a href=""") -Path $Output
        Add-Content -Value ($story.link) -Path $Output
        Add-Content -Value (Write-Output """>") -Path $Output
        Add-Content -Value ($story.title) -Path $Output
        Add-Content -Value (Write-Output "</a>") -Path $Output
        #Add-Content -Value (Write-Output "<font size=""+1"">"$story.feedtitle "</font>") -Path $Output
        Add-Content -Value (Write-Output "<br>") -Path $Output
        }
        Add-Content -Value (Write-Output "<br><a href="readme.txt">readme.txt</a>") -Path $Output
}  


if (Test-Path $Output) {
    Clear-Content $Output
    }
    else {
        New-Item -Path $Output -ItemType File -Confirm
    }
WriteFile
Invoke-Item $Output
Copy-Item -Path .\README.md -Destination .\readme.txt
