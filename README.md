# PowerNews
PowerShell script to get RSS news feeds.

Script now reads from CSV again but with topics and blocklist.

Added "Days" parameter to limit to current stories.

Added "Blocklist" parameter to exclude stories. Need to add filter to URL as well as story titles.

Also added separate script for Slashdot since they have a funky format.

TLS Notes

TLS errors might persist if PowerShell uses TLS 1 (default)
This can be fixed with this command.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
For details:
https://stackoverflow.com/questions/41618766/powershell-invoke-webrequest-fails-with-ssl-tls-secure-channel
