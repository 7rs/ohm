param([string]$Cands, [string]$Out, [string]$LibOut, [long]$MaxBytes = 140000000)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
$base = 'https://api.modrinth.com/v2'
New-Item -ItemType Directory -Force $Out | Out-Null
New-Item -ItemType Directory -Force $LibOut | Out-Null
$skipSlugs = @('adventofascension', 'divinerpg')
$rows = Import-Csv $Cands | Where-Object { $_.title -ne 'NOT FOUND' -and $_.url }
$wc = New-Object System.Net.WebClient
$wc.Headers.Add('User-Agent', 'packwiz-pack-review/1.0')
$libs = New-Object System.Collections.Generic.HashSet[string]
foreach ($r in $rows) {
    foreach ($d in ($r.deps -split ';')) { if ($d -match '^required:(.+)$') { [void]$libs.Add($Matches[1]) } }
    if ($skipSlugs -contains $r.slug) { Write-Output "SKIP(category) $($r.slug)"; continue }
    if ([long]$r.size -gt $MaxBytes) { Write-Output "SKIP(size) $($r.slug)"; continue }
    $dest = Join-Path $Out $r.filename
    if (Test-Path -LiteralPath $dest) { continue }
    try { $wc.DownloadFile($r.url, $dest) } catch { Write-Output ("FAIL " + $r.slug + " " + $_.Exception.Message) }
}
$gv = [uri]::EscapeDataString('["1.20.1"]')
$lo = [uri]::EscapeDataString('["forge"]')
$libRows = @()
foreach ($l in $libs) {
    try {
        $raw = Invoke-RestMethod -Uri "$base/project/$l/version?loaders=$lo&game_versions=$gv" -Headers $ua
        $v = @($raw | ForEach-Object { $_ } | Sort-Object date_published -Descending)
        $rel = @($v | Where-Object { $_.version_type -eq 'release' })
        $pick = if ($rel.Count -gt 0) { $rel[0] } elseif ($v.Count -gt 0) { $v[0] } else { $null }
        if (-not $pick) { Write-Output "NOLIB $l"; continue }
        $f = $pick.files | Where-Object { $_.primary } | Select-Object -First 1
        if (-not $f) { $f = $pick.files | Select-Object -First 1 }
        $libRows += [pscustomobject]@{ slug = $l; version = $pick.version_number; type = $pick.version_type; date = $pick.date_published.Substring(0, 10); size = $f.size; filename = $f.filename }
        $dest = Join-Path $LibOut $f.filename
        if (-not (Test-Path -LiteralPath $dest)) { $wc.DownloadFile($f.url, $dest) }
    } catch { Write-Output ("FAILLIB $l " + $_.Exception.Message) }
    Start-Sleep -Milliseconds 200
}
$libRows | Export-Csv (Join-Path (Split-Path $LibOut -Parent) 'libs.csv') -NoTypeInformation -Encoding utf8
Write-Output ("cand jars=" + (Get-ChildItem $Out -Filter *.jar).Count + " lib jars=" + (Get-ChildItem $LibOut -Filter *.jar).Count)
