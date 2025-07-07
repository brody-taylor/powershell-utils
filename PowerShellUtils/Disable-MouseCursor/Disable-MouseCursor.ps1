function Disable-MouseCursor {
    <#
    .SYNOPSIS
    Disables the system's mouse cursor.

    .DESCRIPTION
    This function disables the mouse cursor by disabling all PnP mouse devices.
    When all mouse devices are disabled, the mouse cursor will not be visible on the screen.

    .NOTES
    Requires administrator privileges.

    .LINK
    Enable-MouseCursor

    .EXAMPLE
    Disable-MouseCursor
    Disables the mouse cursor by disabling all currently enabled mouse devices.
    #>

    # Get currently enabled mice
    $devices = Get-PnpDevice -Class Mouse | Where-Object { $_.Status -eq 'OK' }
    if ($devices.Count -eq 0) {
        throw "Could not find an enabled mouse device to disable"
    }

    # Disable the mouse cursor
    foreach ($device in $devices) {
        Disable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
    }
}

function Enable-MouseCursor {
    <#
    .SYNOPSIS
    Enables the system's mouse cursor.

    .DESCRIPTION
    This function enables the mouse cursor by enabling all PnP mouse devices.
    When all mouse devices are disabled, the mouse cursor will not be visible on the screen.

    .NOTES
    Requires administrator privileges.

    .LINK
    Disable-MouseCursor

    .EXAMPLE
    Enable-MouseCursor
    Enables the mouse cursor by enabling all currently disabled mouse devices.
    #>

    # Get currently disabled mice
    $devices = Get-PnpDevice -Class Mouse | Where-Object { $_.Status -eq 'Error' -or $_.Status -eq 'Disabled' }
    if ($devices.Count -eq 0) {
        throw "Could not find a disabled mouse device to enable"
    }

    # Enable the mouse cursor
    foreach ($device in $devices) {
        Enable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
    }
}
