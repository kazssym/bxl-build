# Find-MsvcVersion.ps1
# Copyright 2025 Linuxfront.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


$VSWHERE = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"

$VSINSTALLDIR = (& $VSWHERE -version "[17,18)" -property "installationPath") + "\"

$VERSION = (Get-ChildItem -Path "${VSINSTALLDIR}VC\Tools\MSVC\" | Sort-Object -Property Name -Descending | Select-Object -First 1).Name

Write-Host "MSVC_VERSION=$VERSION"
"MSVC_VERSION=$VERSION" >> $env:GITHUB_ENV
