
Function Send-SlackAlert
{
    param ([string]$Webhook,[string]$Channel="",[string]$SourceHost="",[string]$Source="",[string]$Severity="",[string]$Message,[string]$User="Powershell",[string]$IconURL="",[string]$Color="danger")

    if (($Webhook -eq "") -or ($Message -eq "")) {
        Write-Host "Usage: Send-Slackalert -Webhook ""<Webhook service ID>"" -Channel ""slack channel name (without #)"" -SourceHost ""<hostname>"" -Source ""<source name>"" -Severity ""<severity text>"" -User ""<user name>"" -IconURL ""<URL to png>"" -Color ""<name or RGB>"" -Message ""<message>"""
        break
    }

    if ($Channel.StartsWith("#")) {
        $Channel=$Channel.TrimStart(1)
    }
    if ($Webhook.StartsWith("/")) {
        $Channel=$Channel.TrimStart(1)
    }
  
    $payload = @{channel="#$Channel";username="$User";icon_url="$IconURL";
        attachments=@(
            @{
                fallback="[$SourceHost][$Severity]";
                pretext="*Source: $Source*";
                text="``````$Message``````";
                color="$Color";
                mrkdwn_in=@("pretext","text");
                fields=@(
                    @{title="Host";value="$SourceHost";short=$true},
                    @{title="Severity";value="$Severity";short=$true}
                )
            }
        )
   }
      
    $payload =  [System.Text.Encoding]::UTF8.GetBytes($(convertTo-JSON -depth 6 $payload))
 
    Invoke-RestMethod -Uri "https://hooks.slack.com/services/$Webhook" -Method Post -Body ($payload)
}
