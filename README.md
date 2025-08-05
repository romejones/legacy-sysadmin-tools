# Legacy Sysadmin Utilities

A collection of PowerShell scripts for legacy Windows environments and sysadmin tasks.

## 📦 Included Scripts

### `Find-RootFolders.ps1`
Searches remote folders (e.g. DFS Roots) for subdirectories matching a given name pattern.

### `Get-RemoteDiskInfo.ps1`
Queries one or more remote servers for logical disk usage and reports free/used space.

### `Measure-FolderSizes.ps1`
Measures and reports the total size of each first-level subfolder in a directory.

## 🛠 Requirements

- PowerShell 5.1+ or PowerShell Core
- WinRM/PowerShell Remoting enabled on remote servers (for remote queries)

