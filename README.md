# PowerNews
PowerShell script to get RSS news feeds.

Trying to incorporate a blacklist/whitelist feature now.


TLS Notes

TLS errors might persist if PowerShell uses TLS 1 (default)
This can be fixed with this command.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
For details:
https://stackoverflow.com/questions/41618766/powershell-invoke-webrequest-fails-with-ssl-tls-secure-channel

Feed Updates!!!

Added 

https://www.economist.com/united-states/rss.xml
https://www.economist.com/international/rss.xml
https://www.economist.com/science-and-technology/rss.xml
https://www.engadget.com/rss.xml
https://www.politico.com/
https://feeds.a.dj.com/rss/RSSWorldNews.xml
https://feeds.a.dj.com/rss/RSSWSJD.xml
https://theweek.com/rss.xml
https://www.foreignaffairs.com/
https://www.theguardian.com/world/rss
http://rss.cnn.com/rss/edition_world.rss
https://www.yahoo.com/news/world/rss
http://www.aljazeera.com/xml/rss/all.xml
http://feeds.bbci.co.uk/news/world/rss.xml
http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml
http://feeds.bbci.co.uk/news/technology/rss.xml
http://feeds.reuters.com/Reuters/domesticNews
http://feeds.reuters.com/Reuters/worldNews
http://feeds.reuters.com/reuters/technologyNews
https://rssfeeds.usatoday.com/UsatodaycomWorld-TopStories
https://rssfeeds.usatoday.com/UsatodaycomNation-TopStories
https://rssfeeds.usatoday.com/usatoday-TechTopStories

Can't find reliabel RSS feeds

https://www.bloomberg.com/

Not added due to custom formatting

https://www.theatlantic.com/
https://archive.nytimes.com/www.nytimes.com/services/xml/rss/index.html
https://www.ap.org/en-us/

Stale feeds

http://feeds.washingtonpost.com/rss/rss_morning-mix
http://feeds.arstechnica.com/arstechnica/apple 
http://feeds.arstechnica.com/arstechnica/technology-lab
http://feeds.arstechnica.com/arstechnica/security

Removed for personal reasons

https://www.buzzfeed.com/world.xml

