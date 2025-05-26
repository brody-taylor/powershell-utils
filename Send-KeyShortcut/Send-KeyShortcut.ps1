function Send-KeyShortcut {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Shortcut
    )

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait($Shortcut)
}
