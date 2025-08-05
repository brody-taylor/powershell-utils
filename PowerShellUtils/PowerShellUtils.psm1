Add-Type -Path "$PSScriptRoot\lib\Interop.dll"

. "$PSScriptRoot\Disable-MouseCursor\Disable-MouseCursor.ps1"
. "$PSScriptRoot\Send-CloseWindow\Send-CloseWindow.ps1"
. "$PSScriptRoot\Send-KeyShortcut\Send-KeyShortcut.ps1"
. "$PSScriptRoot\Start-ElevatedTask\Start-ElevatedTask.ps1"

Export-ModuleMember -Function Disable-MouseCursor, Enable-MouseCursor
Export-ModuleMember -Function Send-CloseWindow
Export-ModuleMember -Function Send-KeyShortcut
Export-ModuleMember -Function Register-ElevatedTask, Start-ElevatedTask, Unregister-ElevatedTask
