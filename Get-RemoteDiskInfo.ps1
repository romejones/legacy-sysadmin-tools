<#
.SYNOPSIS
    Retrieves disk size and free space information from one or more remote servers.

.DESCRIPTION
    Uses WMI (Win32_LogicalDisk) to fetch logical disk usage statistics remotely.
    Outputs the result in a readable and exportable format.

.PARAMETER Servers
    Array of server names to connect to.

.EXAMPLE
    .\Get-RemoteDiskInfo.ps1 -Servers @("Server1", "Server2")
#>

param (
    [Parameter(Mandatory = $true)]
    [string[]]$Servers
)

$Creds = Get-Credential
$results = @()

foreach ($Server in $Servers) {
    Write-Host "`n📡 Connecting to $Server..." -ForegroundColor Cyan
    try {
        $output = Invoke-Command -ComputerName $Server -Credential $Creds -ScriptBlock {
            Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
                [PSCustomObject]@{
                    Server       = $env:COMPUTERNAME
                    Drive        = $_.DeviceID
                    SizeGB       = "{0:N2}" -f ($_.Size / 1GB)
                    FreeGB       = "{0:N2}" -f ($_.FreeSpace / 1GB)
                    FreePercent  = "{0:N1}" -f (($_.FreeSpace / $_.Size) * 100)
                }
            }
        }

        $results += $output
    } catch {
        Write-Warning "❌ Failed to query $Server: $_"
    }
}

$results | Format-Table -AutoSize
