$DOTFILES = (Get-Location).Path

function Get-NextBackupName($path) {
    $backupPath = "$path.bak"
    while (Test-Path $backupPath) {
        $backupPath += ".bak"
    }
    return $backupPath
}

function Create-Symlink {
    param (
        [string]$Target,
        [string]$LinkPath
    )

    if (Test-Path $LinkPath) {
        $backupPath = Get-NextBackupName $LinkPath
        Write-Host "[$(Get-Date -f 'HH:mm:ss')] Moving existing: $LinkPath → $backupPath"
        Move-Item -Path $LinkPath -Destination $backupPath -Force
    }

    Write-Host "[$(Get-Date -f 'HH:mm:ss')] Creating symlink: $LinkPath → $Target"
    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $Target -Force
}


Create-Symlink -Target "$DOTFILES\nvim" -LinkPath "$env:LOCALAPPDATA\nvim"