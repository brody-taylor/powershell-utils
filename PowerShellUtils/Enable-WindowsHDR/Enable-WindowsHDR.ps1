function Enable-WindowsHDR {
    <#
    .SYNOPSIS
    Enables HDR for all active displays that support it.

    .DESCRIPTION
    This function enables HDR for all active displays that support HDR and currently have it disabled.

    .LINK
    Disable-WindowsHDR

    .EXAMPLE
    Enable-WindowsHDR
    Enables HDR for all active displays that support it.
    #>

    $success = [Interop.WindowsHDRHelper]::SetHDR($true)
    if (-not $success) {
        $errorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
        throw "Error enabling HDR: $errorCode"
    }
}

function Disable-WindowsHDR {
    <#
    .SYNOPSIS
    Disables HDR for all active displays.

    .DESCRIPTION
    This function disables HDR for all active displays that currently have HDR enabled.

    .LINK
    Enable-WindowsHDR

    .EXAMPLE
    Disable-WindowsHDR
    Disables HDR for all active displays.
    #>

    $success = [Interop.WindowsHDRHelper]::SetHDR($false)
    if (-not $success) {
        $errorCode = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
        throw "Error disabling HDR: $errorCode"
    }
}
