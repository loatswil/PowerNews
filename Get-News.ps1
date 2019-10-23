# Get-News
# Used to get the news from various sources and writes the output
# to the users desktop or to the screen.

<#
.SYNOPSIS
    Display news from various news locations.
    
.DESCRIPTION
    The cmdlet accepts one input switch, which will cause the output 
    to be displayed to the screen vs. written to a file.

.PARAMETER ShowOutput
    Displays the output to the screen.

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
$Output = "~/Desktop/News.html"
if (Test-Path $Output) {Clear-Content $Output}
Function WriteTechReuters {
    $raw = Invoke-WebRequest http://feeds.reuters.com/reuters/technologyNews
    [xml]$news = $raw.Content
    $stories = @()
    $items = $news.SelectNodes("//item")
        ForEach ($item in $items) {
            $title = $item.title
            $link = $item.link
            $pubdate = $item.pubdate
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate}
            $stories += $story
        }
    $stories = $stories | Sort-Object pubdate | Select-Object -First 10 | Sort-Object -Property pubdate -Descending
    foreach($blah in $stories) {
        Write-Output "<font size=""-3"">"$blah.pubdate"</font>"       
        Write-Output "<a href="""
        $blah.link
        Write-Output """>"
        $blah.title
        Write-Output "</a><br>"
    }
}
Function WriteWorldReuters {
    $raw = Invoke-WebRequest http://feeds.reuters.com/Reuters/worldNews
    [xml]$news = $raw.Content
    $stories = @()
    $items = $news.SelectNodes("//item")
        ForEach ($item in $items) {
            $title = $item.title
            $link = $item.link
            $pubdate = $item.pubdate
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate}
            $stories += $story
        }
    $stories = $stories | Sort-Object pubdate | Select-Object -First 10 | Sort-Object -Property pubdate -Descending
    foreach($blah in $stories) {
        Write-Output "<font size=""-3"">"$blah.pubdate"</font>"       
        Write-Output "<a href="""
        $blah.link
        Write-Output """>"
        $blah.title
        Write-Output "</a><br>"
    }
}
Function WriteUSReuters {
    $raw = Invoke-WebRequest http://feeds.reuters.com/Reuters/domesticNews
    [xml]$news = $raw.Content
    $stories = @()
    $items = $news.SelectNodes("//item")
        ForEach ($item in $items) {
            $title = $item.title
            $link = $item.link
            $pubdate = $item.pubdate
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate}
            $stories += $story
        }
    $stories = $stories | Sort-Object pubdate | Select-Object -First 10 | Sort-Object -Property pubdate -Descending
    foreach($blah in $stories) {
        Write-Output "<font size=""-3"">"$blah.pubdate"</font>"       
        Write-Output "<a href="""
        $blah.link
        Write-Output """>"
        $blah.title
        Write-Output "</a><br>"
    }
}
Function WriteTechBBC {
    $raw = Invoke-WebRequest http://feeds.bbci.co.uk/news/technology/rss.xml
    [xml]$news = $raw.Content
    $stories = @()
    $items = $news.SelectNodes("//item")
        ForEach ($item in $items) {
            $title = $item.title."#cdata-section"
            $link = $item.link
            $pubdate = $item.pubdate.substring(5)
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate}
            $stories += $story
        }
    $stories = $stories | Sort-Object pubdate -Descending | Select-Object -First 5
    # $stories
    foreach($story in $stories) {
        Write-Output "<font size=""-3"">"$story.pubdate"</font>"
        Write-Output "<a href="""
        $story.link
        Write-Output """>"
        $story.title
        Write-Output "</a><br>"
    }
}
Function WriteUSBBC {
    $raw = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml
    [xml]$news = $raw.Content
    $stories = @()
    $items = $news.SelectNodes("//item")
        ForEach ($item in $items) {
            $title = $item.title."#cdata-section"
            $link = $item.link
            $pubdate = $item.pubdate.substring(5)
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate}
            $stories += $story
        }
    $stories = $stories | Sort-Object pubdate -Descending | Select-Object -First 5
    # $stories
    foreach($story in $stories) {
        Write-Output "<font size=""-3"">"$story.pubdate"</font>"
        Write-Output "<a href="""
        $story.link
        Write-Output """>"
        $story.title
        Write-Output "</a><br>"
    }
}
Function WriteWorldBBC {
    $raw = Invoke-WebRequest http://feeds.bbci.co.uk/news/world/rss.xml
    [xml]$news = $raw.Content
    $stories = @()
    $items = $news.SelectNodes("//item")
        ForEach ($item in $items) {
            $title = $item.title."#cdata-section"
            $link = $item.link
            $pubdate = $item.pubdate.substring(5)
            $story = new-object psobject -prop @{title=$title;link=$link;pubdate=$pubdate}
            $stories += $story
        }
    $stories = $stories | Sort-Object pubdate -Descending | Select-Object -First 5
    # $stories
    foreach($story in $stories) {
        Write-Output "<font size=""-3"">"$story.pubdate"</font>"
        Write-Output "<a href="""
        $story.link
        Write-Output """>"
        $story.title
        Write-Output "</a><br>"
    }
}
function WriteFile {
    Add-Content -Value (Write-Output "<b>Reuters News - </b>") -Path $Output
    Add-Content -Value (Get-date) -Path $Output
    Add-Content -Value ("<br>") -Path $Output
    Add-Content -Value (Write-Output "<b><br>Tech News<br></b>") -Path $Output
    Add-Content -Value(WriteTechReuters) -Path $Output
    Add-Content -Value (Write-Output "<b><br>World News<br></b>") -Path $Output
    Add-Content -Value(WriteWorldReuters) -Path $Output
    Add-Content -Value (Write-Output "<b><br>US News<br></b>") -Path $Output
    Add-Content -Value(WriteUSReuters) -Path $Output
    Add-Content -Value (Write-Output "<br><b>BBC News</b><br>") -Path $Output
    Add-Content -Value (Write-Output "<b><br>World News<br></b>") -Path $Output
    Add-Content -Value(WriteWorldBBC) -Path $Output
    Add-Content -Value (Write-Output "<b><br>US News<br></b>") -Path $Output
    Add-Content -Value(WriteUSBBC) -Path $Output
    Add-Content -Value (Write-Output "<b><br>Tech News<br></b>") -Path $Output
    Add-Content -Value(WriteTechBBC) -Path $Output
    }

WriteFile