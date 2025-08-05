# Build the C# interoperability helpers
dotnet clean ./Interop
dotnet publish ./Interop -c Release
$buildOutput = Get-ChildItem -Path "./Interop/bin/Release/netstandard2.0/publish/" -Filter "*.dll"

# Create or clear the DLL destination directory
$destDir = "./PowerShellUtils/lib"
if (!(Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir | Out-Null
} else {
    Get-ChildItem -Path $destDir -File | Remove-Item -Force
}

# Copy DLL(s) to destination
foreach ($dll in $buildOutput) {
    Copy-Item $dll.FullName -Destination $destDir -Force
}