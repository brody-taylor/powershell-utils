function Register-ElevatedTask {
    <#
    .SYNOPSIS
    Registers a task to be run with elevated (administrator) privileges.

    .DESCRIPTION
    This function registers a task for the given executable to be run with elevated (administrator) privileges.
    Once created, running the command through the task does not require administrator privileges.
    This provides a way for applications to be launched without a UAC prompt or by a user without administrator
    privileges, through `Start-ElevatedTask`.

    .NOTES
    Requires administrator privileges to register the task.
    Tasks can be found under the `ElevatedTasks` directory within the Task Scheduler Library.

    .LINK
    Start-ElevatedTask

    .LINK
    Unregister-ElevatedTask

    .EXAMPLE
    Register-ElevatedTask MyApplication "C:\Program Files\MyApplication\MyApplication.exe" -Arguments "-a -b"
    This registers `MyApplication` to be started with elevated privileges, through `Start-ElevatedTask`.
    The executable will also be run with the arguments `-a` and `-b`.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Executable,

        [string]$Arguments = ""
    )

    if ([string]::IsNullOrWhiteSpace($Arguments)) {
        $action = New-ScheduledTaskAction -Execute $Executable
    } else {
        $action = New-ScheduledTaskAction -Execute $Executable -Argument $Arguments
    }

    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

    $description = "Launches $Name with elevated privileges"
    $task = New-ScheduledTask -Action $action -Principal $principal -Description $description

    Register-ScheduledTask -TaskName $Name -TaskPath "\ElevatedTasks\" -InputObject $task -Force | Out-Null
}

function Start-ElevatedTask {
    <#
    .SYNOPSIS
    Starts a previously registered task with elevated (administrator) privileges.

    .DESCRIPTION
    This function runs the given task with elevated (administrator) privileges, without a UAC prompt.

    .LINK
    Register-ElevatedTask

    .LINK
    Unregister-ElevatedTask

    .EXAMPLE
    Start-ElevatedTask MyApplication
    Starts `MyApplication` with elevated privileges, without a UAC prompt.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Start-ScheduledTask -TaskName $Name -TaskPath "\ElevatedTasks\"
}

function Unregister-ElevatedTask {
    <#
    .SYNOPSIS
    Unregisters a previously registered task.

    .DESCRIPTION
    This function deletes the task that was previously registered, so it can no longer be started with elevated
    (administrator) privileges through `Start-ElevatedTask`.

    .NOTES
    Requires administrator privileges to unregister the task.
    Tasks can be found under the `ElevatedTasks` directory within the Task Scheduler Library.

    .LINK
    Register-ElevatedTask

    .LINK
    Start-ElevatedTask

    .EXAMPLE
    Unregister-ElevatedTask MyApplication
    Unregisters `MyApplication` so it can no longer be started through `Start-ElevatedTask`.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Unregister-ScheduledTask -TaskName $Name -TaskPath "\ElevatedTasks\" -Confirm:$false
}
