# sudo New-Item -ItemType SymbolicLink -path $HOME\Documents\WindowsPowerShell\ -name profile.ps1 -value $HOME\dotfiles\powershell\profile.ps1

echo "--------------------------------------------------------------------------------"
echo "Running profile.ps1"

# TODO: Shouldn't there be a way to modify this structurally? This is not unix, so do better.
$env:Path = "$HOME\scoop\shims" + $env:Path
$env:Path = "$(scoop prefix msys2)\mingw64\bin;" + $env:Path
$env:Path = "$HOME\.cask\bin;" + $env:Path

echo "Done running profile.ps1"
echo "--------------------------------------------------------------------------------"
