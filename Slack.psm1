Function New-SlackbotMessage
{
    param ([string]$URL,[string]$Token,[string]$Channel,[string]$Message)

    if (($URL -eq "") -or ($Token -eq "") -or ($Channel -eq "") -or ($Message -eq "")) {
        Write-Host "Usage: New-SlackbotMessage -URL ""<team url, without slack.com>"" -Token ""<your slackbot token-id>"" -Channel ""slack channel name (without #)"" -Message ""<message>"""
        break
    }

    if ($URL -like "*.slack.com") {
        $URL = $URL.Substring(0,$URL.IndexOf("."))
    }    

    if ($Channel.StartsWith("#")) {
        $Channel=$Channel.TrimStart(1)
    }
    
    Invoke-WebRequest -uri "https://$URL.slack.com/services/hooks/slackbot?token=$Token&channel=%23$Channel" -Method POST -Body "$Message"

}
