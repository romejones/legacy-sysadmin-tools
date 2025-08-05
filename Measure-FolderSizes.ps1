<#
.SYNOPSIS
    Calculates the total size of each immediate subfolder in a specified directory.

.DESCRIPTION
    Scans each first-level subfolder and reports its total size (in MB).
    Outputs structured objects and optionally exports the results to a CSV.

.PARAMETER Path
    Root folder to scan for subfolders.

.PARAMETER ExportPath
    Optional path to export results as CSV.

.EXAMPLE
    .\Measure-FolderSizes.ps1 -Path "D:\Media"
    .\Measure-FolderSizes.ps1 -Path "D:\Media" -ExportPath "C:\Exports\folder_sizes.csv"
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [string]$ExportPath
)

if (-not (Test-Path $Path)) {
    Write-Error "❌ The specified path does not exist: $Path"
    exit 1
}

$folders = Get-ChildItem -Path $Path -Directory
$results = foreach ($folder in $folders) {
    $totalSize = Get-ChildItem -Path $folder.FullName -Recurse -Force -File |
                 Measure-Object -Property Length -Sum |
                 Select-Object -ExpandProperty Sum

    [PSCustomObject]@{
        Folder     = $folder.FullName
        SizeMB     = "{0:N2}" -f ($totalSize / 1MB)
        SizeBytes  = $totalSize
    }
}

$results | Format-Table -AutoSize

if ($ExportPath) {
    try {
        $results | Export-Csv -Path $ExportPath -NoTypeInformation
        Write-Host "`n📁 Results exported to: $ExportPath" -ForegroundColor Green
    } catch {
        Write-Warning "⚠ Failed to export to CSV: $_"
    }
}
