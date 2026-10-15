# Sincroniza os assets entre este repositorio e a pasta do cliente.
#
# Uso (no PowerShell, dentro da pasta do ot_oficial_assets):
#   .\sync-assets.ps1 -Cliente C:\OT\ot_oficial_client- -Para cliente   # repositorio -> cliente (depois de git pull)
#   .\sync-assets.ps1 -Cliente C:\OT\ot_oficial_client- -Para repo      # cliente -> repositorio (depois de editar sprites)
#
# A copia e espelhada (/MIR): arquivos que nao existem na origem sao apagados no destino,
# para nao sobrar folha de sprite ou appearances antigo. Antes de copiar, confere se todo
# arquivo citado no catalog-content.json existe na origem.

param(
    [Parameter(Mandatory)] [string]$Cliente,
    [Parameter(Mandatory)] [ValidateSet('cliente', 'repo')] [string]$Para,
    [string]$Versao = '1525'
)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot

if (-not (Test-Path (Join-Path $Cliente 'init.lua'))) {
    throw "Nao parece a pasta do cliente (sem init.lua): $Cliente"
}

$pastas = @("data\things\$Versao", "data\sounds\$Versao")
if ($Para -eq 'cliente') { $origem = $repo; $destino = $Cliente } else { $origem = $Cliente; $destino = $repo }

# ---------------------------------------------------------------- 1. conferir o catalogo
$things  = Join-Path $origem "data\things\$Versao"
$catalog = Get-Content (Join-Path $things 'catalog-content.json') -Raw | ConvertFrom-Json
$faltando = @($catalog | Where-Object { $_.file -and -not (Test-Path (Join-Path $things $_.file)) })
if ($faltando.Count -gt 0) {
    $faltando | Select-Object -First 10 | ForEach-Object { Write-Host "  faltando: $($_.file)" -ForegroundColor Red }
    throw "$($faltando.Count) arquivo(s) do catalog-content.json nao existem em $things"
}

$usados  = @($catalog | Where-Object { $_.type -eq 'appearances' } | ForEach-Object { $_.file })
$sobras  = @(Get-ChildItem $things -Filter 'appearances-*.dat' | Where-Object { $usados -notcontains $_.Name })
if ($sobras.Count -gt 0) {
    Write-Host "Aviso: $($sobras.Count) appearances-*.dat sem uso no catalogo (serao copiados mesmo assim):" -ForegroundColor Yellow
    $sobras | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Yellow }
}

# ---------------------------------------------------------------- 2. copiar
foreach ($pasta in $pastas) {
    $de = Join-Path $origem $pasta
    if (-not (Test-Path $de)) { throw "Nao existe: $de" }
    Write-Host "Copiando $pasta -> $Para..." -ForegroundColor Cyan
    # .client-assets-complete e marcador local do auto-instalador do OTClient
    & robocopy $de (Join-Path $destino $pasta) /MIR /XF '.client-assets-complete' '*.part' /NFL /NDL /NJH /NJS /NP | Out-Null
    # robocopy: 0-7 = sucesso, 8+ = erro
    if ($LASTEXITCODE -ge 8) { throw "robocopy falhou ($LASTEXITCODE): $de" }
}
$global:LASTEXITCODE = 0

Write-Host 'Pronto.' -ForegroundColor Green
if ($Para -eq 'repo') {
    Write-Host 'Agora revise com "git status" e faca commit/push neste repositorio.'
}
