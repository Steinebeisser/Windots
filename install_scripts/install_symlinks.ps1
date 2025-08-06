function Get-NextBackupName($path) {
    $backupBase = "$path.bak"

    if (-not (Test-Path $backupBase)) {
        return $backupBase
    }

    $directory = Split-Path $path -Parent
    $fileName = [System.IO.Path]::GetFileName($path)
    $files = Get-ChildItem -Path $directory -Filter "$fileName.bak*" -Name

    $maxNum = 0

    $pattern = [regex]::Escape($fileName) + '\.bak(\d+)?$'

    foreach ($file in $files) {
        if ($file -match $pattern) {
            $num = if ($matches[1]) { [int]$matches[1] } else { 0 }
            if ($num -gt $maxNum) {
                $maxNum = $num
            }
        }
    }

    if ($maxNum -eq 0) {
        return "$path.bak1"
    } else {
        return "$path.bak$($maxNum + 1)"
    }
}

function New-Symlink
{
    param (
        [string]$Target,
        [string]$LinkPath
    )

    if (Test-Path $LinkPath)
    {
        $backupPath = Get-NextBackupName $LinkPath
        Write-Host "[$(Get-Date -f 'HH:mm:ss')] Moving existing: $LinkPath -> $backupPath"
        Move-Item -Path $LinkPath -Destination $backupPath -Force
    }

    Write-Host "[$(Get-Date -f 'HH:mm:ss')] Creating symlink: $LinkPath -> $Target"
    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $Target -Force
}

$DOTFILES = (Get-Location).Path

New-Symlink -Target "$DOTFILES\nvim" -LinkPath "$env:LOCALAPPDATA\nvim"
New-Symlink -Target "$DOTFILES\.wezterm.lua" -LinkPath "$env:USERPROFILE\.wezterm.lua"
New-Symlink -Target "$DOTFILES\.glzr" -LinkPath "$env:USERPROFILE\.glzr"
New-Symlink -Target "$DOTFILES\.gitconfig" -LinkPath "$env:USERPROFILE\.gitconfig"
New-Symlink -Target "$DOTFILES\Microsoft.PowerShell_profile.ps1" -LinkPath "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
New-Symlink -Target "$DOTFILES\starship.toml" -LinkPath "$env:USERPROFILE\starship.toml"
