# sudo New-Item -ItemType SymbolicLink -path $HOME\Documents\WindowsPowerShell\ -name profile.ps1 -value $HOME\dotfiles\powershell\profile.ps1

echo "--------------------------------------------------------------------------------"
echo "Running profile.ps1"

# TODO: Shouldn't there be a way to modify this structurally? This is not unix, so do better.

$msys2_prefix = "$(scoop prefix msys2)"
$env:Path += ";$msys2_prefix\usr\local\bin"
$env:Path += ";$msys2_prefix\usr\bin"
$env:Path = "$msys2_prefix\mingw64\bin;" + $env:Path

$env:Path = "$HOME\scoop\shims;" + $env:Path

$env:Path = "$HOME\.cask\bin;" + $env:Path

$env:Path = "$HOME\bin;" + $env:Path

$env:Path += ";C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.22.27905\bin\HostX86\x86"

# https://github.com/dahlbyk/posh-sshell
# https://itsallinthecode.com/powershell-using-git-with-ssh-keys-on-windows-10/
try {
    Import-Module posh-sshell
    Start-SshAgent
} catch {
    echo "Fail to set up ssh agent integration"
}

echo "Done running profile.ps1"
echo "--------------------------------------------------------------------------------"
