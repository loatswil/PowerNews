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

[CmdletBinding()]

Param(
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.ValidateNotNullOrEmptyAttribute()]
        [switch]
        $ShowOutput
)

$allstories = @()

$GuadrianWorld = Invoke-WebRequest https://www.theguardian.com/world/rss
$CNNWorld = Invoke-WebRequest http://rss.cnn.com/rss/edition_world.rss
$YahooWorld = Invoke-WebRequest https://www.yahoo.com/news/world/rss
$AlJazeeraAll = Invoke-WebRequest http://www.aljazeera.com/xml/rss/all.xml
$BuzzfeedWorld = Invoke-WebRequest https://www.buzzfeed.com/world.xml
$BBCWorld = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/rss.xml
$BBCUS = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml
$BBCTech = Invoke-WebRequest http://feeds.bbci.co.uk/news/technology/rss.xml
$ReutersUS = Invoke-WebRequest http://feeds.reuters.com/Reuters/domesticNews
$ReutersWorld = Invoke-WebRequest http://feeds.reuters.com/Reuters/worldNews
$ReutersTech = Invoke-WebRequest http://feeds.reuters.com/reuters/technologyNews
$WaPo = Invoke-WebRequest http://feeds.washingtonpost.com/rss/rss_morning-mix
$ARSApple = Invoke-WebRequest http://feeds.arstechnica.com/arstechnica/apple 
$ARSIT = Invoke-WebRequest http://feeds.arstechnica.com/arstechnica/technology-lab
$ARSSec = Invoke-WebRequest http://feeds.arstechnica.com/arstechnica/security
function PullNews1($feed) {
    [xml]$feedxml = $feed.Content
    $stories = @()
    $items = $feedxml.rss.channel.item
        ForEach ($item in $items) {
            $title = $item.title."#cdata-section"
            $link = $item.link
            $pubdate = $item.pubdate
            $pubdate = $pubdate | Get-Date -ErrorAction SilentlyContinue
            $desc = $item.description."#cdata-section"
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate;desc=$desc}
            $stories += $story
        }
    $stories = $stories | Sort-Object pubdate -Descending | Select-Object -First 3 | Sort-Object -Property pubdate -Descending 
    $stories
}
function PullNews2($feed) {
    [xml]$feedxml = $feed.Content
    $stories = @()
    $items = $feedxml.rss.channel.item
        ForEach ($item in $items) {
            $title = $item.title
            $link = $item.link
            $pubdate = $item.pubdate
            $pubdate = $pubdate | Get-Date -ErrorAction SilentlyContinue
            $desc = $item.description
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate;desc=$desc}
            $stories += $story
        }
    $stories = $stories | Sort-Object pubdate -Descending | Select-Object -First 3 | Sort-Object -Property pubdate -Descending
    $stories
}

$allstories += PullNews1($CNNWorld)
$allstories += PullNews2($BuzzfeedWorld) 
$allstories += PullNews2($GuadrianWorld)
$allstories += PullNews2($YahooWorld)
$allstories += PullNews1($AlJazeeraAll)
$allstories += PullNews1($BBCWorld)
$allstories += PullNews1($BBCUS)
$allstories += PullNews1($BBCTech)
$allstories += PullNews2($ReutersUS)
$allstories += PullNews2($ReutersTech)
$allstories += PullNews2($ReutersWorld)
$allstories += PullNews2($WaPo)
$allstories += PullNews2($ARSApple)
$allstories += PullNews2($ARSIT)
$allstories += PullNews2($ARSSec)

$allstories = $allstories | Sort-Object -Property pubdate -Descending
function WriteFile {
    Add-Content -Value (Write-Output "<b>News - </b>") -Path $Output
    Add-Content -Value (Get-date) -Path $Output
    Add-Content -Value ("<br>") -Path $Output
    foreach($story in $allstories) {
        Add-Content -Value (Write-Output "<font size=""-3"">"$story.pubdate "</font>") -Path $Output       
        Add-Content -Value (Write-Output "&nbsp;") -Path $Output
        Add-Content -Value (Write-Output "<a href=""") -Path $Output
        Add-Content -Value ($story.link) -Path $Output
        Add-Content -Value (Write-Output """>") -Path $Output
        Add-Content -Value ($story.title) -Path $Output
        Add-Content -Value (Write-Output "</a><br>") -Path $Output
        }
}
function WriteHost {
    Write-Host "News"(Get-Date)
    foreach($story in $allstories) {
        $story.pubdate
        $story.title
        }
    }

if($ShowOutput) {
    WriteHost
    Exit
}
else {
    $Output = "~/Desktop/News.html"
    if (Test-Path $Output) {
        Clear-Content $Output
        }
        else {
            New-Item -Path $Output -ItemType File -Confirm
        }
    WriteFile
    Invoke-Item $Output
}