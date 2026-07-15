param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$ProjectPath
)

$projectRoot = (Resolve-Path -LiteralPath $ProjectPath).Path
$sourceRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
$sourceAgents = Join-Path $sourceRoot 'agents'
$targetAgents = Join-Path $projectRoot '.codex/agents'

if (-not (Test-Path -LiteralPath $sourceAgents -PathType Container)) {
  throw "OPSBOARD agent templates are missing from $sourceAgents"
}

New-Item -ItemType Directory -Force -Path $targetAgents | Out-Null
Get-ChildItem -LiteralPath $sourceAgents -Filter 'opsboard-*.toml' -File | ForEach-Object {
  $target = Join-Path $targetAgents $_.Name
  if ((Test-Path -LiteralPath $target) -and ((Get-Content -LiteralPath $_.FullName -Raw) -cne (Get-Content -LiteralPath $target -Raw))) {
    throw "Refusing to overwrite local agent template: $target"
  }
  Copy-Item -LiteralPath $_.FullName -Destination $target -Force
}

Write-Output "Installed OPSBOARD agent templates in $targetAgents"
