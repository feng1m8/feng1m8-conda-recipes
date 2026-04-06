<# :
@echo off
setlocal enabledelayedexpansion
set "args=%*"
set "args=!args:"="""!"
powershell -Nologo -NoProfile -ExecutionPolicy Bypass -Command "iex ((Get-Content '%~f0') -join [Environment]::Newline); main '%~f0' -- !args!"
exit /b
#>


function New-Ar5ivistTempDir {
    $Base = "C:\ProgramData\ar5ivist\Temp"
    if (-not (Test-Path $Base)) {
        New-Item -ItemType Directory -Path $Base | Out-Null
    }

    $Dir = Join-Path $Base ([System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $Dir | Out-Null
    return $Dir
}


function Update-DesArgs {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args,

        [string]$NewValue = "REPLACED"
    )

    $updated = @()
    $oldValues = @()

    for ($i = 0; $i -lt $Args.Count; $i++) {
        $arg = $Args[$i]

        if ($arg -match '^--(des[^=]*)=(.+)$') {
            $key = $matches[1]
            $old = $matches[2]

            $path = Split-Path $old -Parent
            $name = Split-Path $old -Leaf

            $oldValues = [PSCustomObject]@{
                Path = $path
                Name = $name
            }

            $updated += """--$key=$NewValue\$name"""
            continue
        }

        if ($arg -match '^--(des.+)$') {
            $key = $matches[1]
            $old = $Args[$i + 1]

            $path = Split-Path $old -Parent
            $name = Split-Path $old -Leaf

            $oldValues = [PSCustomObject]@{
                Path = $path
                Name = $name
            }

            $updated += $arg
            $updated += """$NewValue\$name"""

            $i++
            continue
        }

        $updated += """$arg"""
    }

    return [PSCustomObject]@{
        UpdatedArgs = $updated
        OldValues   = $oldValues
    }
}



function main {
    if ($args.Count -gt 1) {
        $rest = $args[1..($args.Count-1)]
    } else {
        $rest = @()
    }

    $dir = New-Ar5ivistTempDir
    $update = Update-DesArgs -Args $rest -NewValue $dir

    $ScriptDir = Split-Path -Parent $args[0]
    $UcrtDir   = Join-Path $ScriptDir "..\ucrt64\bin" | Resolve-Path
    $latexmlDir   = Join-Path $ScriptDir "..\..\bin" | Resolve-Path
    $latexmlDir2   = Join-Path $ScriptDir "..\..\Scripts" | Resolve-Path
    $optDir= Join-Path $ScriptDir "..\opt\ar5iv-bindings" | Resolve-Path
    $env:PATH = "$UcrtDir;$ScriptDir;$latexmlDir2;$env:PATH"

    & "$ScriptDir\perl.exe" `
    "$latexmlDir\latexmlc" `
    "--preload=[nobibtex,ids,localrawstyles,nobreakuntex,magnify=1.8,zoomout=1.8,tokenlimit=249999999,iflimit=3599999,absorblimit=1299999,pushbacklimit=599999]latexml.sty" `
    "--preload=ar5iv.sty" `
    "--path=$optDir\bindings" `
    "--path=$optDir\supported_originals" `
    "--format=html5" `
    "--pmml" `
    "--cmml" `
    "--mathtex" `
    "--timeout=2700" `
    "--noinvisibletimes" `
    "--nodefaultresources" `
    "--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv.min.css" `
    "--css=https://cdn.jsdelivr.net/gh/dginev/ar5iv-css@0.7.9/css/ar5iv-fonts.min.css" `
    $update.UpdatedArgs

    $targetPath = $update.OldValues.Path    
    if (![string]::IsNullOrWhiteSpace($targetPath)) {
        if (-not (Test-Path $targetPath)) {
            # Write-Host "目标路径不存在，正在创建: $targetPath"
            New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
        }
    }

    Copy-Item -Path (Join-Path $dir "*") `
                -Destination $targetPath `
                -Recurse -Force

    if (Test-Path $dir) {
        Remove-Item $dir -Recurse -Force
    }
}
