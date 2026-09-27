<#
.SYNOPSIS
  Read-only Windows hardware and relevant-software overview.
.DESCRIPTION
  Lists basic OS/CPU/RAM/GPU, drive-letter capacities, and versions of allowlisted
  development tools. Does NOT enumerate files, networks, serial numbers,
  credentials, activation keys, product IDs, usernames or installed-app paths.
  Run as an ordinary (non-admin) Windows PowerShell user.
#>
[CmdletBinding()]
param([string]$OutputPath = "")
$ErrorActionPreference = "Stop"
$report = [ordered]@{
  captured_utc = (Get-Date).ToUniversalTime().ToString("o")
  report_type = "local_system_metadata_only"
  os = $null
  cpu = @()
  ram_gib_approx = $null
  gpu = @()
  volumes = @()
  relevant_apps = @()
  mysql_services = @()
}
try {
  $os = Get-CimInstance Win32_OperatingSystem
  $report.os = [ordered]@{ edition=$os.Caption; version=$os.Version; build=$os.BuildNumber }
} catch { $report.os = "unavailable" }
try {
  $report.cpu = @(Get-CimInstance Win32_Processor | ForEach-Object {
    [pscustomobject]@{ model=$_.Name.Trim(); cores=$_.NumberOfCores; logical_processors=$_.NumberOfLogicalProcessors }
  })
} catch { $report.cpu = @() }
try {
  $sys = Get-CimInstance Win32_ComputerSystem
  $report.ram_gib_approx = [math]::Round($sys.TotalPhysicalMemory / 1GB, 1)
} catch { $report.ram_gib_approx = $null }
try {
  $report.gpu = @(Get-CimInstance Win32_VideoController | ForEach-Object { $_.Name })
} catch { $report.gpu = @() }
try {
  $report.volumes = @(Get-CimInstance Win32_LogicalDisk | Where-Object {
    $_.DriveType -in @(2,3)
  } | ForEach-Object {
    [pscustomobject]@{
      letter=$_.DeviceID
      type=if ($_.DriveType -eq 2) { "removable" } else { "local" }
      size_gib_approx=[math]::Round($_.Size / 1GB, 1)
      free_gib_approx=[math]::Round($_.FreeSpace / 1GB, 1)
    }
  })
} catch { $report.volumes = @() }
$filter = "Docker|Malwarebytes|MySQL|SQL Server Management Studio|Microsoft Access|Power Automate|Visual Studio Code|Google Drive|OneDrive|^Git( |$)|^Python( |$)|^Node.js|Ollama|PowerShell 7"
$appList = [System.Collections.Generic.List[object]]::new()
foreach ($key in @(
  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
  "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
  "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
)) {
  try {
    foreach ($item in (Get-ChildItem -Path $key -ErrorAction Stop)) {
      try {
        $appName = $item.GetValue("DisplayName", "")
        if (-not $appName -or $appName -notmatch $filter) { continue }
        $version = $item.GetValue("DisplayVersion", "")
        $appList.Add([pscustomobject]@{ name=$appName; version=$version })
      } catch { continue }
    }
  } catch { continue }
}
$report.relevant_apps = @($appList | Sort-Object name,version -Unique)
try {
  $report.mysql_services = @(Get-Service -Name "MySQL*" -ErrorAction SilentlyContinue |
    ForEach-Object { [pscustomobject]@{ status=[string]$_.Status; start_type=[string]$_.StartType } })
} catch { $report.mysql_services = @() }
$json = [pscustomobject]$report | ConvertTo-Json -Depth 6
Write-Output $json
if ($OutputPath) {
  $parent = Split-Path -Parent $OutputPath
  if (-not $parent -or -not (Test-Path -LiteralPath $parent -PathType Container)) {
    throw "Output folder must already exist and be private."
  }
  $json | Out-File -LiteralPath $OutputPath -Encoding utf8 -NoClobber
  Write-Output "Saved locally; review before sharing. Never upload to public GitHub."
}
