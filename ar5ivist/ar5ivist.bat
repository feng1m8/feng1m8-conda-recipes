<# :
@echo off
setlocal enabledelayedexpansion
set "args=%*"
set "args=!args:"="""!"
powershell -Nologo -NoProfile -ExecutionPolicy Bypass -Command "iex ((Get-Content '%~f0') -join [Environment]::Newline); main '%~f0' -- !args!"
exit /b
#>


function New-TempPath {
    $TempPath = "C:\ProgramData\ar5ivist\Temp"

    if (-not (Test-Path $TempPath)) {
        New-Item -ItemType "Directory" -Path $TempPath -Force | Out-Null
    }

    $TempPath = Join-Path $TempPath ([System.IO.Path]::GetRandomFileName())
    New-Item -ItemType "Directory" -Path $TempPath -Force | Out-Null

    return $TempPath
}


function Update-ArgsValue {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$InputArgs,

        [string]$NewValue
    )

    $NewArgs = @()
    $OutPath = @()

    for ($i = 0; $i -lt $InputArgs.Count; $i++) {
        $Arg = $InputArgs[$i]

        if ($Arg -match '^--(des[^=]*)=(.+)$') {
            $Key = $matches[1]
            $RealPath = $matches[2]

            $OutPath = Split-Path $RealPath -Parent
            $FileName = Split-Path $RealPath -Leaf

            $NewArgs += """--$Key=$NewValue\$FileName"""
            continue
        }

        if ($Arg -match '^--(des.+)$') {
            if ($i + 1 -ge $InputArgs.Count) {
                $NewArgs += """$Arg"""
                continue
            }

            $RealPath = $InputArgs[$i + 1]

            $OutPath = Split-Path $RealPath -Parent
            $FileName = Split-Path $RealPath -Leaf

            $NewArgs += $Arg
            $NewArgs += """$NewValue\$FileName"""

            $i++
            continue
        }

        $NewArgs += """$Arg"""
    }

    return [PSCustomObject]@{
        NewArgs = $NewArgs
        OutPath = $OutPath
    }
}


function main {
    if ($Args.Count -gt 1) {
        $RemainingArgs = $Args[1..($Args.Count-1)]
    } else {
        $RemainingArgs = @()
    }

    $TempPath = New-TempPath
    $RemainingArgs = Update-ArgsValue -InputArgs $RemainingArgs -NewValue $TempPath

    $NewArgs = $RemainingArgs.NewArgs
    $OutPath = $RemainingArgs.OutPath

    $BinDir = Split-Path -Parent $Args[0]
    $UcrtDir = Join-Path $BinDir "..\ucrt64\bin" -Resolve
    $SiteDir = Join-Path $BinDir "..\site\bin" -Resolve
    $ScriptsDir = Join-Path $BinDir "..\..\Scripts" -Resolve
    $OptDir = Join-Path $BinDir "..\opt\ar5iv-bindings" -Resolve
    $env:PATH = "$UcrtDir;$BinDir;$ScriptsDir;$env:PATH"

    & "$BinDir\perl.exe" `
    "$SiteDir\latexmlc" `
    "--preload=[nobibtex,ids,localrawstyles,nobreakuntex,magnify=1.8,zoomout=1.8,tokenlimit=249999999,iflimit=3599999,absorblimit=1299999,pushbacklimit=599999]latexml.sty" `
    "--preload=ar5iv.sty" `
    "--path=$OptDir\bindings" `
    "--path=$OptDir\supported_originals" `
    "--format=html5" `
    "--pmml" `
    "--cmml" `
    "--mathtex" `
    "--timeout=2700" `
    "--noinvisibletimes" `
    "--nodefaultresources" `
    "--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv.min.css" `
    "--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv-fonts.min.css" `
    $NewArgs

    if (-not ([string]::IsNullOrWhiteSpace($OutPath))) {
        if (-not (Test-Path $OutPath)) {
            New-Item -ItemType "Directory" -Path $OutPath -Force | Out-Null
        }
    }

    Move-Item -Path (Join-Path $TempPath "*") -Destination $OutPath -Force

    if (Test-Path $TempPath) {
        Remove-Item $TempPath -Recurse -Force
    }
}
