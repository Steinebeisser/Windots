# Windots

> [!WARNING]
> not much tested
> no guarantee that it will work
> they can be missing components so that something will not work, if you find anything write an issue
> im probably gonna improve it, someday

This is my windows config with install script to install everything i want

## Installation

> This will promt u 2 times to elevate a powershell session

**What it includes**

- Scoop
- Powershell 7
- MSYS2 Mingw64
- allot of utils/languages/runtimes
- dotfiles
- focus on c and c#
- neovim
- powertoys
- window manager, term emulator
- many more

### Via Git


```bash
git clone https://github.com/Steinebeisser/Windots
cd Windots
.\install.ps1
```

### Via Zip

```ps1
Expand-Archive -Path .\Windots-master.zip -DestinationPath .\Windots
cd Windots\Windots-master
Unlock-File .\install.ps1
.\install.ps1
```

## What I use and how

### GlazeWM with Zebar

> [!NOTE] Zebar doesnt install its Starter config if installed via Scoop so open it go into the Widget Browser and get the Starter pack or any pack that is compatible with GlazeWM

### Neovim as Editor

> [!NOTE] currently not possible to install roslyn automatically with Mason so Run manually inside neovim
```vim
:MasonInstall roslyn
```

### Git + GPG

> using gpg commit signing

#### 1. Create a Key:
```
gpg --full-generate-key
```

|Step|What to do|
|Key Type|1 - RSA + RSA|
|Key size|4096|
|Expiration|wahtever u want, i choose 0|
|Name|Your Git Name|
|Email|Your Git Email|
|Comment|Comment|
|Passphrase|Dont choose 1234|

#### 2. List Keys and get Key Id

```
gpg --list-secret-keys --keyid-format=long
```

The ID is the part after rsa/4096

#### 3. Export Key to github/etc

```
gpg --armor --export YOURKEYID
```

Copy the output that looks like this
```
-----BEGIN PGP PUBLIC KEY BLOCK-----
...
-----END PGP PUBLIC KEY BLOCK-----
```

For Github its under \
Settings -> SSG and GPG key -> "New GPG key"


Then update your [.gitconfig](.gitconfig)

```
[user]
    name = YOUR NAME
    email = YOUR EMAIL
    signingkey = YOUR GPG KEY
```

> [!IMPORTANT]
> you have to edit your gpg program either using this command
> ```
> git config --global gpg.program "C:/Users/YOUR_USER/scoop/apps/gpg/current/bin/gpg.exe"
>```
> Or edit it manually or you wont be able to sign


> or just disable gpg sign


### Wezterm with pwsh
Shell: PowerShell 7 (pwsh)

for aliases take a look in [pwsh profile](Microsoft.PowerShell_profile.ps1)

### Packages via Scoop

look into the [scoop install file](install_scripts/install_scoop.ps1)
