function Enable-MouseCursor {
    <#
    .SYNOPSIS
    Enables or disables the system's mouse cursor.

    .DESCRIPTION
    This function enables or disables the mouse cursor by enabling or disabling all PnP mouse devices.
    When all mouse devices are disabled, the mouse cursor will not be visible on the screen.

    .NOTES
    Requires administrative privileges.

    .EXAMPLE
    Enable-MouseCursor
    Enables the mouse cursor by enabling all currently disabled mouse devices.
    .EXAMPLE
    Enable-MouseCursor $false
    Disables the mouse cursor by disabling all currently enabled mouse devices.
    #>
    param(
        [Parameter(Mandatory = $false)]
        [bool]$Enable = $true
    )

    # Get currently disabled/enabled mice
    if ($Enable) {
        $devices = Get-PnpDevice -Class Mouse | Where-Object { $_.Status -eq 'Error' -or $_.Status -eq 'Disabled' }
        if ($devices.Count -eq 0) {
            throw "Could not find a disabled mouse device to enable"
        }
    } else {
        $devices = Get-PnpDevice -Class Mouse | Where-Object { $_.Status -eq 'OK' }
        if ($devices.Count -eq 0) {
            throw "Could not find an enabled mouse device to disable"
        }
    }

    # Enable or disable the mouse cursor
    foreach ($device in $devices) {
        if ($Enable) {
            Enable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
        } else {
            Disable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
        }
    }
}