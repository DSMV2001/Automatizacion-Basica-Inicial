# Diagnostic script for Windows PowerShell.
# Read before running. Read-only. Does NOT read environment variables,
# database credentials, API keys, account details, container configuration, or files.
# Review the output before sharing; redact any personal information.

$ErrorActionPreference = 'Continue'

function Invoke-Check {
    param(
        [string]$Title,
        [string]$CommandName,
        [scriptblock]$Command
    )
    Write-Output ""
    Write-Output "==== $Title ===="
    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        Write-Output "$CommandName no está instalado o no se encuentra en PATH."
        return
    }
    try {
        & $Command 2>&1 | ForEach-Object { Write-Output $_ }
    } catch {
        Write-Output "No se pudo completar la comprobación. Revisa el error localmente."
    }
}

Write-Output "AI Automation Hub | diagnóstico LOCAL y de solo lectura"
Write-Output "No publiques el resultado sin revisarlo y eliminar datos personales."

try {
    Get-CimInstance Win32_OperatingSystem |
        Select-Object Caption, Version, BuildNumber |
        Format-List | Out-String | Write-Output
} catch {
    Write-Output "No se pudo obtener la versión de Windows."
}

Invoke-Check "Versión WSL" "wsl.exe" { wsl.exe --version }
Invoke-Check "Distribuciones WSL" "wsl.exe" { wsl.exe --list --verbose }
Invoke-Check "Docker Engine y cliente" "docker.exe" {
    docker.exe version --format 'Cliente: {{.Client.Version}} | Engine: {{.Server.Version}}'
}
Invoke-Check "Docker Compose" "docker.exe" { docker.exe compose version }
Invoke-Check "Git" "git.exe" { git.exe --version }
Invoke-Check "Python" "python.exe" { python.exe --version }
Invoke-Check "Cliente MySQL (si está en PATH)" "mysql.exe" { mysql.exe --version }

Write-Output ""
Write-Output "==== Servicios MySQL de Windows ===="
Get-Service -Name 'MySQL*' -ErrorAction SilentlyContinue |
    Select-Object Name, Status, StartType |
    Format-Table -AutoSize | Out-String | Write-Output

Write-Output ""
Write-Output "Diagnóstico concluido. No se han cambiado configuraciones."
Write-Output "MySQL Workbench Server Status, Power Automate y paneles de IA se revisan manualmente."
