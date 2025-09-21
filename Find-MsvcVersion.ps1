# Find-VsToolsVersion.ps1

$VSWHERE = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"

$VSINSTALLDIR = (& $VSWHERE -version "[17,18)" -property "installationPath") + "\"

$VERSION = (Get-ChildItem -Path "${VSINSTALLDIR}VC\Tools\MSVC\" | Sort-Object -Property Name -Descending | Select-Object -First 1).Name

Write-Host "MSVC_VERSION=$VERSION"
"MSVC_VERSION=$VERSION" >> $env:GITHUB_ENV
