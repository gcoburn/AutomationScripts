# PowerShell Script to be used in vRO on provision
# Replace the {$variables} in this script at execution time

[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$clnt = New-Object System.Net.WebClient
$clnt.DownloadFile("{$url}","{$file}")

Invoke-Expression "c:\prepare_vra_template.ps1 {$appliance} {$iaas} {$pass}"
