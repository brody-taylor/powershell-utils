function Send-CloseWindow {
    <#
    .SYNOPSIS
    Sends a close command to the specified process.

    .DESCRIPTION
    This function sends a close command `SC_CLOSE` to the main window of a specified process.
    It simulates the action of clicking the close button on the window, rather than terminating the process.

    .EXAMPLE
    Send-CloseWindow MyApplication
    Sends a close command to `MyApplication`.
    If `MyApplication` is set to minimize to the system tray on close, it will do so instead of terminating.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProcessName
    )

    # Find the process by name
    $process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 }
    if (-not $process) {
        throw "Process not found: '$ProcessName'"
    }

    # Post the SC_CLOSE message to the main window of the process
    $success = [Interop.CloseWindowHelper]::CloseWindow($process.MainWindowHandle)

    if (-not $success) {
        $errorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
        throw "Error sending SC_CLOSE to process '$ProcessName': $errorCode"
    }
}
