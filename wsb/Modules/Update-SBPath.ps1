Function Update-SBPath {

    $NewPath =@(
        ([System.Environment]::GetEnvironmentVariable("PATH","Machine")) -split ";"
        ([System.Environment]::GetEnvironmentVariable("PATH","User")) -split ";"
    )
    $env:path = ($NewPath|Select-Object -Unique) -join ";"
}
