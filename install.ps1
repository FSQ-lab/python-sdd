param(
    [string]$Target = (Get-Location).Path,
    [switch]$Force,
    [switch]$Yes
)

$ErrorActionPreference = "Stop"

$RepoUrl = if ($env:PYTHON_SDD_REPO_URL) { $env:PYTHON_SDD_REPO_URL } else { "https://github.com/FSQ-lab/python-sdd" }
$Ref = if ($env:PYTHON_SDD_REF) { $env:PYTHON_SDD_REF } else { "main" }
$TempDir = $null

if ($env:PYTHON_SDD_INSTALL_FORCE -eq "1") {
    $Force = $true
}
if ($env:PYTHON_SDD_INSTALL_YES -eq "1") {
    $Yes = $true
}

function Write-Step {
    param([string]$Message)
    Write-Host $Message
}

function Fail {
    param([string]$Message)
    throw $Message
}

function Get-RelativePath {
    param([string]$Path)
    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $fullTarget = [System.IO.Path]::GetFullPath($script:TargetDir)
    if ($fullPath.StartsWith($fullTarget, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $fullPath.Substring($fullTarget.Length).TrimStart([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    }
    return $Path
}

function Confirm-Install {
    if ($Yes) {
        return
    }

    $answer = Read-Host "Install Python SDD skills into $script:TargetDir? [y/N]"
    if ($answer -notin @("y", "Y", "yes", "YES")) {
        Fail "installation cancelled"
    }
}

function Resolve-SourceDir {
    if ($env:PYTHON_SDD_SOURCE_DIR) {
        return (Resolve-Path $env:PYTHON_SDD_SOURCE_DIR).Path
    }

    if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "skills")) -and (Test-Path (Join-Path $PSScriptRoot "templates"))) {
        return $PSScriptRoot
    }

    $script:TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("python-sdd-" + [System.Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $script:TempDir | Out-Null

    $archive = Join-Path $script:TempDir "source.zip"
    $url = "$RepoUrl/archive/$Ref.zip"
    Write-Step "Downloading Python SDD from $url"
    Invoke-WebRequest -Uri $url -OutFile $archive
    Expand-Archive -Path $archive -DestinationPath $script:TempDir

    $source = Get-ChildItem -Path $script:TempDir -Directory | Select-Object -First 1
    if (-not $source) {
        Fail "downloaded archive did not contain a source directory"
    }
    return $source.FullName
}

function Copy-FileIfNeeded {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path $Source -PathType Leaf)) {
        Fail "source file missing: $Source"
    }
    if ((Test-Path $Destination) -and -not $Force) {
        Write-Step "Skipped existing $(Get-RelativePath $Destination)"
        return
    }

    $parent = Split-Path -Parent $Destination
    if ($parent) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Copy-Item -Path $Source -Destination $Destination -Force:$Force
    Write-Step "Installed $(Get-RelativePath $Destination)"
}

function Copy-DirectoryIfNeeded {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path $Source -PathType Container)) {
        Fail "source directory missing: $Source"
    }
    if (Test-Path $Destination) {
        if (-not $Force) {
            Write-Step "Skipped existing $(Get-RelativePath $Destination)"
            return
        }
        Remove-Item -Path $Destination -Recurse -Force
    }

    $parent = Split-Path -Parent $Destination
    if ($parent) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Copy-Item -Path $Source -Destination $Destination -Recurse
    Write-Step "Installed $(Get-RelativePath $Destination)"
}

function New-SpecIfMissing {
    $destination = Join-Path $script:TargetDir "SPEC.md"
    if (Test-Path $destination) {
        Write-Step "Kept existing SPEC.md"
        return
    }

    @"
# SPEC

## Purpose

Describe the product, service, or library this repository implements.

## Architecture

Record the current package boundaries, public APIs, domain model, and infrastructure decisions.

## Behavior

Track accepted user-facing and developer-facing behavior. Keep this synchronized with implementation.

## Verification

List the commands that prove the implementation matches this SPEC.
"@ | Set-Content -Path $destination -Encoding UTF8
    Write-Step "Installed SPEC.md"
}

try {
    $script:TargetDir = (Resolve-Path $Target).Path
    Confirm-Install
    $SourceDir = Resolve-SourceDir

    if (-not (Test-Path (Join-Path $SourceDir "skills") -PathType Container)) {
        Fail "invalid source: missing skills directory in $SourceDir"
    }
    if (-not (Test-Path (Join-Path $SourceDir "templates") -PathType Container)) {
        Fail "invalid source: missing templates directory in $SourceDir"
    }

    Copy-DirectoryIfNeeded (Join-Path $SourceDir "skills/requirements-to-design") (Join-Path $script:TargetDir ".github/skills/requirements-to-design")
    Copy-DirectoryIfNeeded (Join-Path $SourceDir "skills/spec-driven") (Join-Path $script:TargetDir ".github/skills/spec-driven")
    Copy-DirectoryIfNeeded (Join-Path $SourceDir "skills/python-architecture") (Join-Path $script:TargetDir ".github/skills/python-architecture")
    Copy-DirectoryIfNeeded (Join-Path $SourceDir "skills/spec-implementation-audit") (Join-Path $script:TargetDir ".github/skills/spec-implementation-audit")

    Copy-FileIfNeeded (Join-Path $SourceDir "templates/AGENTS.md") (Join-Path $script:TargetDir "AGENTS.md")
    Copy-FileIfNeeded (Join-Path $SourceDir "templates/CLAUDE.md") (Join-Path $script:TargetDir "CLAUDE.md")
    Copy-FileIfNeeded (Join-Path $SourceDir "templates/vscode/copilot-instructions.md") (Join-Path $script:TargetDir ".github/copilot-instructions.md")
    Copy-FileIfNeeded (Join-Path $SourceDir "templates/vscode/requirements-to-design.prompt.md") (Join-Path $script:TargetDir ".github/prompts/requirements-to-design.prompt.md")
    Copy-FileIfNeeded (Join-Path $SourceDir "templates/vscode/spec-driven.prompt.md") (Join-Path $script:TargetDir ".github/prompts/spec-driven.prompt.md")
    New-SpecIfMissing

    Write-Step "Python SDD installation finished."
}
finally {
    if ($TempDir -and (Test-Path $TempDir)) {
        Remove-Item -Path $TempDir -Recurse -Force
    }
}
