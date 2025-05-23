function Send-CloseWindow {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProcessName
    )

    # Import CloseWindowHelper class if not already loaded
    if (-not ("CloseWindowHelper" -as [type])) {
        Add-Type -Path "$PSScriptRoot\CloseWindowHelper.cs"
    }

    # Find the process by name
    $process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 }
    if (-not $process) {
        throw "Process not found: '$ProcessName'"
    }

    # Post the SC_CLOSE message to the main window of the process
    $success = [CloseWindowHelper]::PostMessage(
        $process.MainWindowHandle,
        [CloseWindowHelper]::WM_SYSCOMMAND,
        [IntPtr][CloseWindowHelper]::SC_CLOSE,
        [IntPtr]::Zero
    )
        
    if (-not $success) {
        $errorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
        throw "Error sending SC_CLOSE to process '$ProcessName': $errorCode"
    }
}
