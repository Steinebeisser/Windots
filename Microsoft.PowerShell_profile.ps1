# Import required modules for compatibility
Import-Module -Name Microsoft.PowerShell.Utility -ErrorAction SilentlyContinue

Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$HOME\starship.toml"

Del alias:gl -Force
Del alias:gc -Force
Del alias:gp -Force
Del alias:gu -Force
Del alias:sleep -Force

function ga   { git add @args }
function gap  { git add --patch @args }
function gb   { git branch @args }
function gba  { git branch --all @args }
function gbf  { git for-each-ref --sort=-committerdate refs/heads/ --format="%(refname:short) - %(committerdate:relative)" }
function gc   { git commit @args }
function gca  { git commit --amend --no-edit @args }
function gce  { git commit --amend @args }
function gco  { git checkout @args }
function gcl  { git clone --recursive @args }
function gd   { git diff --output-indicator-new=" " --output-indicator-old=" " @args }
function gds  { git diff --staged --output-indicator-new=" " --output-indicator-old=" " @args }
function gi   { git init @args }
function gl   { git log --graph --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n" @args }
function gla   { gl --all }
function gm   { git merge @args }
function gn   { git checkout -b @args }
function gp   { git push @args }
function gr   { git reset @args }
function gs   { git status --short @args }
function gu   { git pull @args }
function ..   { cd .. }
function ...  { cd ..\.. }

function zip($src, $dest = $null) {
    $resolvedSrc = Resolve-Path -Path $src
    $fullSrc = $resolvedSrc.Path

    if (-not (Test-Path $fullSrc)) {
        throw "Source path '$src' does not exist."
    }

    $srcName = Split-Path -Path $fullSrc -Leaf
    $parentDir = Split-Path -Path $fullSrc -Parent

    if (-not $dest) {
        $dest = Join-Path -Path $parentDir -ChildPath "$srcName.zip"
    } elseif (-not ($dest -like "*.zip")) {
        $dest = "$dest.zip"
    }

    Compress-Archive -Path $fullSrc -DestinationPath $dest -Force
    Write-Host "✔ Created zip: $dest"
}
