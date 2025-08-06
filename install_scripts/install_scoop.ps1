Import-Module -Name Microsoft.PowerShell.Utility -ErrorAction Stop
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)"

$env:SCOOP_POWERSHELL = "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command 'Import-Module Microsoft.PowerShell.Utility -ErrorAction Stop; & {0}'"

[Environment]::SetEnvironmentVariable("SCOOP_POWERSHELL", $env:SCOOP_POWERSHELL, "Process")

function Test-ScoopInstalled
{
    return $null -ne (Get-Command scoop -ErrorAction SilentlyContinue)
}

# TODO: check if installation failed
function Test-ScoopPackageInstalled
{
    param (
        [string]$package
    )
    return $null -ne ($exported.apps | Where-Object { $_.name -eq $package })
}

Write-Host "[INFO] Checking if Scoop is installed..."
if (!(Test-ScoopInstalled))
{
    Write-Host "[INFO] Installing Scoop..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    
    $scoopInstaller = Invoke-RestMethod -Uri https://get.scoop.sh
    Invoke-Expression $scoopInstaller
    
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
} else
{
    Write-Host "[INFO] Scoop already installed"
}

$global:exported = scoop export | ConvertFrom-Json

Write-Host "[INFO] Making sure git is installed to add buckets"
if (!(Test-ScoopPackageInstalled git))
{
    Write-Host "[INFO] Installing git"
    scoop install git
} else
{
    Write-Host "[OK] git is already installed"
}

Write-Host "[INFO] Updating scoop and adding extras"
scoop bucket add extras 2>$null
scoop bucket add versions 2>$null
scoop bucket add nerd-fonts 2>$null
scoop update


$scoop_packages = @(
    # file utils
    "7zip", 
    "bat",
    "coreutils",
    "duf",
    "dua",
    "eza",
    "fd",
    "less",

    # search/diff/git
    "delta",
    "diff-so-fancy",
    "fzf",
    "gh",
    "git",
    "gpg",
    "grep",
    "lazygit",
    "ripgrep",

    # shell
    "starship",
    "scoop-completion",

    # Languages/Runtimes/Editors
    "nodejs",
    "ruby",
    "pipx",
    "python",
    "llvm",
    "neovim",
    "dotnet-sdk",       #9
    "dotnet-sdk-lts",   #8

    # system info
    "btop",
    "neofetch",
    "winfetch",
    "onefetch",
    "tokei",

    # fonts/ui
    "JetBrainsMono-NF-Mono",
    "glazewm",
    "zebar",

    # utils
    "cowsay",
    "gawk",
    "yq",
    "jq",
    "tldr"
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

Write-Host "[INFO] Done installing all packages"
