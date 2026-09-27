<#
.SYNOPSIS
  Metadata-only folder inventory. Explicitly selected roots only.
.DESCRIPTION
  No file contents, names, individual paths, hashes, secret values or cloud API
  calls are read. Nothing is deleted, copied or uploaded. Summaries are printed
  to the screen; an optional JSON copy is created only if -OutputPath is passed.
  Do not put results in a PUBLIC Git repository. Review before sharing.
.EXAMPLE
  .\scripts\inventory_metadata.ps1 -Roots @("$HOME\Documents")
.EXAMPLE
  .\scripts\inventory_metadata.ps1 -Roots @("$HOME\Documents", "E:\SelectedFolder") -OutputPath "$HOME\Desktop\local_summary.json"
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidateCount(1, 10)]
  [string[]]$Roots,
  [ValidateRange(100, 1000000)]
  [int]$MaxFilesPerRoot = 50000,
  [ValidateRange(1, 120)]
  [int]$MaxMinutesPerRoot = 10,
  [string]$OutputPath = ""
)
$ErrorActionPreference = "Stop"
$extensionClasses = @{
  ".pdf"="documents"; ".docx"="documents"; ".doc"="documents";
  ".xlsx"="documents"; ".xls"="documents"; ".pptx"="documents";
  ".ppt"="documents"; ".odt"="documents"; ".ods"="documents";
  ".csv"="structured-data"; ".json"="structured-data"; ".xml"="structured-data";
  ".sql"="structured-data"; ".accdb"="structured-data"; ".mdb"="structured-data";
  ".db"="structured-data"; ".sqlite"="structured-data";
  ".gpx"="sports-data"; ".fit"="sports-data"; ".tcx"="sports-data";
  ".py"="source-code"; ".js"="source-code"; ".ts"="source-code";
  ".ps1"="source-code"; ".ipynb"="source-code"; ".yml"="source-code";
  ".yaml"="source-code"; ".md"="source-code";
  ".jpg"="media"; ".jpeg"="media"; ".png"="media"; ".webp"="media";
  ".heic"="media"; ".mp4"="media";
  ".zip"="archives"; ".7z"="archives"; ".tar"="archives"
}
$summaries = @()
$index = 0
foreach ($root in $Roots) {
  $index++
  if (-not (Test-Path -LiteralPath $root -PathType Container)) {
    Write-Warning "Fuente $index omitida: carpeta no disponible."
    continue
  }
  $deadline = (Get-Date).AddMinutes($MaxMinutesPerRoot)
  $count = 0
  $truncated = $false
  $byType = @{}
  $unreadableCount = 0
  # Bounded directory-by-directory traversal: no full-root materialization.
  # Reparse points (including junctions/symlinks) are never followed.
  $pending = [System.Collections.Generic.Stack[string]]::new()
  $pending.Push((Resolve-Path -LiteralPath $root).ProviderPath)
  while ($pending.Count -gt 0) {
    if ($count -ge $MaxFilesPerRoot -or (Get-Date) -gt $deadline) {
      $truncated = $true
      break
    }
    $folder = $pending.Pop()
    try {
      $children = Get-ChildItem -LiteralPath $folder -ErrorAction Stop
    } catch {
      $unreadableCount++
      continue
    }
    foreach ($item in $children) {
      if ($count -ge $MaxFilesPerRoot -or (Get-Date) -gt $deadline) {
        $truncated = $true
        break
      }
      if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { continue }
      if ($item.PSIsContainer) {
        $pending.Push($item.FullName)
        continue
      }
      if (-not ($item -is [System.IO.FileInfo])) { continue }
      $count++
      $ext = $item.Extension.ToLowerInvariant()
      $category = if ($extensionClasses.ContainsKey($ext)) { $extensionClasses[$ext] } else { "other" }
      if (-not $byType.ContainsKey($category)) { $byType[$category] = @{ count=0; bytes=0L } }
      $byType[$category].count++
      $byType[$category].bytes += $item.Length
    }
  }
  $groups = foreach ($kind in @($byType.Keys | Sort-Object)) {
    [pscustomobject]@{
      category = $kind
      files = $byType[$kind].count
      mebibytes_approx = [math]::Round($byType[$kind].bytes / 1MB, 2)
    }
  }
  $summaries += [pscustomobject]@{
    source_label = "Fuente_$index"
    inspected_files = $count
    category_summary = @($groups)
    truncated = $truncated
    unreadable_entries_approx = $unreadableCount
  }
}
$report = [pscustomobject]@{
  generated_utc = (Get-Date).ToUniversalTime().ToString("o")
  analysis_type = "metadata_only"
  no_file_content_read = $true
  no_paths_or_filenames_exported = $true
  roots_requested = $Roots.Count
  source_summaries = @($summaries)
}
$json = $report | ConvertTo-Json -Depth 6
Write-Output $json
if ($OutputPath) {
  $parent = Split-Path -Parent $OutputPath
  if (-not $parent -or -not (Test-Path -LiteralPath $parent -PathType Container)) {
    throw "La carpeta de salida debe existir. Usa una carpeta PRIVADA, fuera de Git."
  }
  $json | Out-File -LiteralPath $OutputPath -Encoding utf8 -NoClobber
  Write-Output "Copia local generada; revisa el JSON antes de compartirlo."
}
