<#
.SYNOPSIS
    Searches a specified directory on one or more remote servers for folders matching a given string.

.DESCRIPTION
    Connects to remote servers using credentials and scans a target directory (e.g., DFS root share) for folders
    whose names match a specified pattern.

.PARAMETER Servers
    Array of server names to connect to.

.PARAMETER RootPath
    Path to scan on the remote servers (e.g., F:\DFS_Roots).

.PARAMETER Match
    String or pattern to match folder names against (case-insensitive).

.EXAMPLE
    .\Find-RootFolders.ps1 -Servers @("Server1", "Server2") -RootPath "F:\DFS_Roots" -Match "Finance"
#>

param (
    [Parameter(Mandatory = $true)]
    [string[]]$Servers,

    [Parameter(Mandatory = $true)]
    [string]$RootPath,

    [Parameter(Mandatory = $true)]
    [string]$Match
)

$Creds = Get-Credential

foreach ($Server in $Servers) {
    Write-Host "`n🔍 Scanning $RootPath on $Server..." -ForegroundColor Cyan
    try {
        Invoke-Command -ComputerName $Server -Credential $Creds -ScriptBlock {
            param ($RootPath, $Match)
            if (Test-Path $RootPath) {
                $Folders = Get-ChildItem -Path $RootPath -Directory
                foreach ($Folder in $Folders) {
                    if ($Folder.Name -like "*$Match*") {
                        Write-Host "$env:COMPUTERNAME`t$($Folder.Name)" -ForegroundColor Green
                    }
                }
            } else {
                Write-Warning "$RootPath not found on $env:COMPUTERNAME"
            }
        } -ArgumentList $RootPath, $Match
    } catch {
        Write-Warning "❌ Failed to connect to $Server: $_"
    }
}
