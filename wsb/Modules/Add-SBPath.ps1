# Add local installed programs to PATH

Function Add-SBPath {

    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Path
    )

    $OldPath = ([System.Environment]::GetEnvironmentVariable("PATH","Machine")) -split ";"

    try {
        $AddPath = (Resolve-Path $Path -ErrorAction Stop).Path
        $TmpPath = @(
            $OldPath
            $AddPath
        )
        $NewPath = $TmpPath -join ";"
        [System.Environment]::SetEnvironmentVariable("PATH",$NewPath,"Machine")
    }
    catch {
        throw "The given Path, $path don't exist."
    }
}
