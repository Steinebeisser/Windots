$msys2Path = "C:\msys64"
if (!(Test-Path $msys2Path))
{
    Write-Host "[ERROR] MSYS2 installation not found at $msys2Path. Please verify the installation path."
    exit 1
}
$mingw_packages = @(
    "mingw-w64-x86_64-gcc",
    "mingw-w64-x86_64-cmake",
    "mingw-w64-x86_64-make",
    "mingw-w64-x86_64-gdb",
    "mingw-w64-x86_64-ninja",
    "mingw-w64-x86_64-valgrind",
    "mingw-w64-x86_64-meson"
)

Write-Host "[INFO] Setting up MSYS2 environment..."
$msys2Shell = "$msys2Path\usr\bin\bash.exe"
$pacmanCommand = "pacman -Syu --noconfirm"
$installCommand = "pacman -S --noconfirm " + ($mingw_packages -join " ")

# TODO: mingw shell most of times needs restart after updating core sysetm
Write-Host "[INFO] Updating MSYS2 package database..."
Start-Process -FilePath $msys2Shell -ArgumentList "--login -c '$pacmanCommand'" -Wait -NoNewWindow

Write-Host "[INFO] Installing specified MSYS2 packages..."
Start-Process -FilePath $msys2Shell -ArgumentList "--login -c '$installCommand'" -Wait -NoNewWindow

Write-Host "[INFO] Verifying installed packages..."
foreach ($package in $mingw_packages)
{
    $checkCommand = "pacman -Qs $package"
    Start-Process -FilePath $msys2Shell -ArgumentList "--login -c '$checkCommand'" -Wait -NoNewWindow -PassThru -RedirectStandardOutput "pacman_output.txt"
    $output = Get-Content -Path "pacman_output.txt" -ErrorAction SilentlyContinue
    if ($output -match $package)
    {
        Write-Host "[INFO] Package $package is installed."
    } else
    {
        Write-Host "[ERROR] Package $package is not installed. Please check for errors."
    }
}

Write-Host "[INFO] MSYS2 setup and package installation completed."
