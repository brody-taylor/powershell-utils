function Switch-ToggleExecutable {
    <#
    .SYNOPSIS
    Provides on-off state management for running an executable.

    .DESCRIPTION
    This function runs the given executable while managing a boolean state variable.
    The executable will be run with the logical not of its current state as an argument.

    .NOTES
    On initial call, the current state is assumed off and will be executed with the on (true) argument.
    The state is only updated if the executable returns a successful (0) exit code or does not return an exit code.

    .LINK
    Set-ToggleExecutable

    .EXAMPLE
    Switch-ToggleExecutable "C:\Program Files\MyApplication\MyScript.ps1"
    On initial call, runs the script as `MyScript.ps1 $true`.
    If execution is successful, the subsequent call will run as `MyScript.ps1 $false`.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Executable
    )

    $executablePath = Format-ExecutablePath($Executable)

    $statePath = Join-Path $env:LOCALAPPDATA "PowerShellUtils/SwitchToggleExecutable/state.xml"
    New-Item -Path (Split-Path $statePath -Parent) -ItemType Directory -Force | Out-Null

    # Load existing state data
    $stateData = if (Test-Path $statePath) {
        Import-CliXml $statePath
    } else {
        @{}
    }

    # Determine the current state
    $currentState = $false;
    if ($stateData.ContainsKey($executablePath)) {
        $currentState = $stateData[$executablePath]
    }

    $newState = -not $currentState
    $exitCode = & $executablePath $newState

    # Update the state on success
    if ($null -eq $exitCode -or $exitCode -eq 0) {
        $stateData[$executablePath] = $newState
        $stateData | Export-CliXml $statePath
    }
}

function Set-ToggleExecutable {
    <#
    .SYNOPSIS
    Sets the on-off state for an executable.

    .DESCRIPTION
    This function runs the given executable with the given state as an argument.
    The managed state variable for the executable will be overridden to the new state.

    .NOTES
    The state is only overridden if the executable returns a successful (0) exit code or does not return an exit code.

    .LINK
    Switch-ToggleExecutable

    .EXAMPLE
    Set-ToggleExecutable "C:\Program Files\MyApplication\MyScript.ps1" $false
    Runs the script as `MyScript.ps1 $false` and updates the current state variable to `$false`.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Executable,

        [Parameter(Mandatory = $true)]
        [bool]$State
    )

    $executablePath = Format-ExecutablePath($Executable);

    $statePath = Join-Path $env:LOCALAPPDATA "PowerShellUtils/SwitchToggleExecutable/state.xml"
    New-Item -Path (Split-Path $statePath -Parent) -ItemType Directory -Force | Out-Null

    # Load existing state data
    $stateData = if (Test-Path $statePath) {
        Import-CliXml $statePath
    } else {
        @{}
    }

    $exitCode = & $executablePath $State

    # Set the new state on success
    if ($null -eq $exitCode -or $exitCode -eq 0) {
        $stateData[$executablePath] = $State
        $stateData | Export-CliXml $statePath
    }
}

function Format-ExecutablePath {
    <#
    .SYNOPSIS
    Validates that executable and returns its absolute path.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Executable
    )

    # Validate the script file path
    if (-not (Test-Path $Executable -PathType Leaf)) {
        throw "Executable not found: '$Executable'"
    }

    # Convert path to absolute
    $formattedPath = Resolve-Path -Path $Executable | Select-Object -ExpandProperty Path

    # Return lower for case insensitivity
    return $formattedPath.ToLower()
}
