function Complete-ElevatedTaskName {
    <#
    .SYNOPSIS
    Argument completion function for registered task names.

    .LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_argument_completion
    #>
    param(
        [string] $commandName,
        [string] $parameterName,
        [string] $wordToComplete,
        [System.Management.Automation.Language.CommandAst] $commandAst,
        [System.Collections.IDictionary] $fakeBoundParameters
    )

    # Get all registered tasks
    $tasks = Get-ScheduledTask -TaskPath "\ElevatedTasks\" -ErrorAction SilentlyContinue
    if (-not $tasks) {
        # No registered tasks
        return
    }

    # Create a completion result for each matching task name
    $tasks | Where-Object { $_.TaskName -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new(
            $_.TaskName,
            $_.TaskName,
            'ParameterValue',
            $_.Description
        )
    }
}
