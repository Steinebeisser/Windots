param(
    [string]$Mode = "default"
)

$ScriptName = ".\install.ps1"

function Start-NonAdminProcess
{
    Write-Host "Restarting script in NON-ADMIN mode for Scoop operations..."
    $CurrentLocation = Get-Location
    $ScriptPath = "$CurrentLocation/$ScriptName"

    $Arguments = @(
        '-NoProfile',
        '-ExecutionPolicy Bypass',
        '-NoExit',
        '-Command',
        "& { Set-Location '$CurrentLocation'; & '$ScriptPath' --no-admin }"
    )

    Start-Process -FilePath "powershell.exe" -ArgumentList $Arguments
    exit
}

function Test-Admin
{
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $windowsPrincipal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $windowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-NextBackupName($path)
{
    $backupPath = "$path.bak"
    while (Test-Path $backupPath)
    {
        $backupPath += ".bak"
    }
    return $backupPath
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
        Write-Host "[$(Get-Date -f 'HH:mm:ss')] Moving existing: $LinkPath → $backupPath"
        Move-Item -Path $LinkPath -Destination $backupPath -Force
    }

    Write-Host "[$(Get-Date -f 'HH:mm:ss')] Creating symlink: $LinkPath → $Target"
    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $Target -Force
}

function Get-SymlinkSetup
{
    $DOTFILES = (Get-Location).Path

    New-Symlink -Target "$DOTFILES\nvim" -LinkPath "$env:LOCALAPPDATA\nvim"
    New-Symlink -Target "$DOTFILES\.wezterm.lua" -LinkPath "$env:USERPROFILE\.wezterm.lua"
    New-Symlink -Target "$DOTFILES\.glzr" -LinkPath "$env:USERPROFILE\.glzr"
    New-Symlink -Target "$DOTFILES\.gitconfig" -LinkPath "$env:USERPROFILE\.gitconfig"
    New-Symlink -Target "$DOTFILES\Microsoft.PowerShell_profile.ps1" -LinkPath "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    New-Symlink -Target "$DOTFILES\starship.toml" -LinkPath "$env:USERPROFILE\starship.toml"
}

function Test-ScoopInstalled
{
    return $null -ne (Get-Command scoop -ErrorAction SilentlyContinue)
}

# TODO: check if package failed to install
function Test-ScoopPackageInstalled
{
    param ([string]$package)
    return $null -ne ($exported.apps | Where-Object { $_.name -eq $package })
}

function Test-PwshInstalled
{
    return $null -ne (Get-Command pwsh -ErrorAction SilentlyContinue)
}

function Get-ScoopSetup
{
    Write-Host "[INFO] Checking if pwsh is installed"
    if (!(Test-PwshInstalled))
    {
        Write-Host "[INFO] Installing PowerShell 7, using winget..."
        winget install Microsoft.PowerShell
    } else
    {
        Write-Host "[INFO] PowerShell 7 is already installed, checking for updates"
        winget upgrade Microsoft.PowerShell
    }

    Write-Host "[INFO] Checking if Scoop is installed..."
    if (!(Test-ScoopInstalled))
    {
        Write-Host "[INFO] Installing Scoop..."
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    } else
    {
        Write-Host "[INFO] Scoop already installed"
    }

    Write-Host "[INFO] Updating scoop and adding extras"
    scoop bucket add extras 2>$null
    scoop bucket add versions 2>$null
    scoop update

    $global:exported = scoop export | ConvertFrom-Json

    $scoop_packages = @(
        "7zip", 
        "bat",
        "btop",
        "coreutils",
        "cowsay",
        "delta",
        "diff-so-fancy",
        "duf",
        "eza",
        "fzf",
        "gawk",
        "glazewm",
        "grep",
        "lazygit",
        "less",
        "llvm",
        "neofetch",
        "neovim",
        "pipx",
        "ruby",
        "starship",
        "tokei",
        "winfetch",
        "mingw",
        "nodejs",
        "make",
        "cmake",
        "ninja",
        "gpg",
        "git"
    )

    foreach ($pkg in $scoop_packages)
    {
        Write-Host "[INFO] Checking if $pkg is installed via scoop..."
        if (-not (Test-ScoopPackageInstalled $pkg))
        {
            Write-Host "[INFO] Installing $pkg via scoop..."
            scoop install $pkg
        } else
        {
            Write-Host "[OK] $pkg is already installed."
        }
    }

    Write-Host "[INFO] Done installing all packages, restart your terminal and launch wezterm"
}

if ($Mode -eq "--no-admin")
{
    Get-ScoopSetup
    exit
}

if (-not (Test-Admin))
{
    Write-Host "Not elevated - requesting admin privileges..."
    $CurrentLocation = Get-Location
    $ScriptPath = $MyInvocation.MyCommand.Path

    $Arguments = @(
        '-NoProfile',
        '-ExecutionPolicy Bypass',
        '-NoExit',
        '-Command',
        "& { Set-Location '$CurrentLocation'; & '$ScriptPath' }"
    )

    Start-Process -FilePath "powershell.exe" -Verb RunAs -ArgumentList $Arguments
    exit
}

Write-Host "[INFO] Running as administrator, setting up symlinks..."
Get-SymlinkSetup

Start-NonAdminProcess # scoop setup
