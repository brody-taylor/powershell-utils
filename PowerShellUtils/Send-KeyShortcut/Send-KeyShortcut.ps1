function Send-KeyShortcut {
    <#
    .SYNOPSIS
    Sends a keyboard shortcut to the active window.

    .DESCRIPTION
    This function sends a keyboard shortcut to the active window using the `SendKeys` class from `System.Windows.Forms`.

    .EXAMPLE
    Send-KeyboardShortcut "^+{ESC}"
    Sends the `Ctrl+Shift+Esc` keyboard shortcut, which typically opens the Task Manager.

    .NOTES
    See .NET documentation for the full list of supported key codes.

    .LINK
    https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.sendkeys
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Shortcut
    )

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait($Shortcut)
}
