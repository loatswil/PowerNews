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

# Nuke the progress bar for performance boost (y)
$ProgressPreference = "SilentlyContinue"

$allfeeds = @()
$allstories = @()
$Output = "~/Desktop/News.html"

$allfeeds = Import-Csv -Path .\news-sources.csv
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


Write-Output "Pulling data from the sources..."

ForEach ($feed in $allfeeds) {
    $rawfeed = Invoke-WebRequest $feed.feed # -verbose for troubleshooting
    if ($feed.type -like "1") {
        Write-Host "Fetching"$feed.feed
        $allstories += PullNews1($rawfeed)
    }
    else {
        Write-Host "Fetching"$feed.feed
        $allstories += PullNews2($rawfeed)
    }

}

Write-Host "Sorting..."    
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

Write-Host "Writing file..."    
WriteFile
Invoke-Item $Output
Copy-Item -Path .\README.md -Destination .\readme.txt