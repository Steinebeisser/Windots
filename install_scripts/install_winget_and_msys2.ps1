# TODO: check if anything exists outside of scoop
function Test-WingetPackageInstalled
{
    param (
        [string]$PackageId
    )

    $installed = winget list --id $PackageId 2>$null | Select-String $PackageId
    return $null -ne $installed
}

Write-Host "[INFO] Checking if MSYS2 is installed"
if (!(Test-WingetPackageInstalled "MSYS2.MSYS2"))
{
    Write-Host "[INFO] Installing MSYS2 using winget..."
    winget install --id MSYS2.MSYS2 --accept-source-agreements --accept-package-agreements
} else
{
    Write-Host "[INFO] MSYS2 is already installed, upgrading if necessary..."
    winget upgrade --id MSYS2.MSYS2 --accept-source-agreements --accept-package-agreements
}

$msys2SetupScript = "$PSScriptRoot\install_msys2_stuff.ps1"

Write-Host "[INFO] Running MSYS2 setup script..."
Start-Process powershell -ArgumentList "-NoExit -Command cd '$PSScriptRoot'; $msys2SetupScript"

$wingetPackages = @(
    "MICROSOFT.PowerShell",
    "MICROSOFT.PowerToys"
)

foreach ($pkg in $wingetPackages)
{
    Write-Host "[INFO] Checking fi $pkg is installed"
    if (!(Test-WingetPackageInstalled $pkg))
    {
        Write-Host "[INFO] Installing $pkg using winget..."
        winget install --id $pkg --accept-source-agreements --accept-package-agreements
    } else
    {
        Write-Host "[INFO] $pkg is already installed, updating if possible..."
        winget upgrade --id $pkg --accept-source-agreements --accept-package-agreements
    }
}
