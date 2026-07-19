param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectPath
)

$projectRoot = (Resolve-Path $ProjectPath).Path
$failures = 0

function Fail([string]$Message) {
  Write-Error "FAIL: $Message"
  $script:failures++
}

git -C $projectRoot rev-parse --show-toplevel *> $null
if ($LASTEXITCODE -ne 0) { Fail "not a Git worktree: $projectRoot" }

if (-not (Get-Command git-bug -ErrorAction SilentlyContinue)) {
  Fail "git-bug is required to read the durable backlog"
}

foreach ($path in '.opsboard/project.yaml', '.opsboard/sprints', '.opsboard/demos', '.opsboard/approvals') {
  if (-not (Test-Path (Join-Path $projectRoot $path))) {
    Fail "missing required project-contract path: $path"
  }
}

$contract = Join-Path $projectRoot '.opsboard/project.yaml'
if (Test-Path $contract) {
  $content = Get-Content -Raw $contract
  foreach ($key in 'version', 'slug', 'display_name', 'default_ref') {
    if ($content -notmatch "(?m)^$key:") { Fail "project.yaml is missing required key: $key" }
  }
}

$sprints = Join-Path $projectRoot '.opsboard/sprints'
if (Test-Path $sprints) {
  Get-ChildItem -Path $sprints -Filter '*.md' -File | ForEach-Object {
    $sprintId = $_.BaseName
    $sprintContent = Get-Content -Raw $_.FullName
    $needsPackage = ($sprintContent -match '(?i)plan-lock|plan_lock|plan lock') -or
      ($sprintContent -match "\.opsboard/approvals/$sprintId|approvals/$sprintId")
    if ($needsPackage) {
      $packageDir = Join-Path $projectRoot ".opsboard/approvals/$sprintId"
      if (-not (Test-Path $packageDir)) {
        Fail "sprint $sprintId declares plan-lock/approvals but missing directory: .opsboard/approvals/$sprintId"
      } else {
        $readme = Join-Path $packageDir 'README.md'
        $caps = Join-Path $packageDir 'capabilities.md'
        if (-not (Test-Path $readme) -and -not (Test-Path $caps)) {
          Fail "sprint $sprintId approval package lacks README.md or capabilities.md"
        }
      }
    }
  }
}

if ((Get-Command git-bug -ErrorAction SilentlyContinue) -and (Test-Path $sprints)) {
  $issueIds = @(Get-ChildItem -Path $sprints -File -Recurse | Select-String -Pattern 'git-bug `([0-9a-f]{7,64})`' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
  if ($issueIds.Count -gt 0) {
    Push-Location $projectRoot
    try { $availableIds = @(git-bug bug --format id 2>$null) } finally { Pop-Location }
    if ($availableIds.Count -eq 0) { Fail 'git-bug cannot list local issues; fetch refs/bugs/* and refs/identities/* first' }
    foreach ($issueId in $issueIds) {
      $matches = @($availableIds | Where-Object { $_ -like "$issueId*" })
      if ($matches.Count -ne 1) {
        Fail "referenced git-bug issue is unavailable or ambiguous locally: $issueId"
        continue
      }
      Push-Location $projectRoot
      try { git-bug bug show $matches[0] *> $null } finally { Pop-Location }
      if ($LASTEXITCODE -ne 0) { Fail "referenced git-bug issue cannot be read locally: $issueId" }
    }
  }
}

if ($failures -gt 0) {
  Write-Error "OPSBOARD project validation failed ($failures problem(s))."
  exit 1
}

Write-Output "OPSBOARD project validation passed: $projectRoot"
