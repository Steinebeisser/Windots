Get-ChildItem -Recurse -Path $PSScriptRoot | Unblock-File # if downloading zip powershell scripts need to be unblocked as they are not signed

function Start-SubScript
{
    param (
        [string]$Path,
        [bool]$Admin = $false,
        [bool]$UseProfile = $false
    )

    $pwsh = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($pwsh)
    {
        $installed_powershell = "pwsh.exe"
    } else
    {
        $installed_powershell = "powershell.exe"
    }

    $escapedPath = $Path.Replace("'", "''")

    $args = @(
        '-NoExit',
        '-ExecutionPolicy', 'Bypass',
        '-Command', "Import-Module Microsoft.PowerShell.Utility; cd '$PWD'; & '$escapedPath'"
    )

    if (! ($UseProfile))
    {
        $args = @('-NoProfile') + $args
    }

    if ($Admin)
    {
        Write-Host "Launching $Path with elevated privileges..."
        $proc = Start-Process -FilePath $installed_powershell -ArgumentList $args -Verb RunAs -PassThru
    } else
    {
        Write-Host "Launching $Path as non-elevated..."
        $proc = Start-Process -FilePath $installed_powershell -ArgumentList $args -PassThru -ErrorAction Stop
    }

    return $proc
}

$procs = @()
# $procs += Start-SubScript "$PSScriptRoot\install_scripts\install_symlinks.ps1" -Admin $true -UseProfile $false
# $procs += Start-SubScript "$PSScriptRoot\install_scripts\install_scoop.ps1"  -Admin $false -UseProfile $true
$procs += Start-SubScript "$PSScriptRoot\install_scripts\install_winget_and_msys2.ps1" -Admin $true -UseProfile $false

Write-Host "Started install tasks in parallel. Waiting for them to finish..."
