param([string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
$base = 'https://api.modrinth.com/v2'
$slugs = @('almostunified', 'citadel', 'coroutil', 'guideme', 'irons-lib', 'playeranimator', 'geckolib', 'patchouli', 'platform', 'pehkui', 'spawn-animations-compats', 'true-ending-ender-dragon-music', 'crackerslib')
New-Item -ItemType Directory -Force $Out | Out-Null
$gv = [uri]::EscapeDataString('["1.20.1"]')
$lo = [uri]::EscapeDataString('["forge"]')
$rows = @()
$vers = @{}
foreach ($s in $slugs) {
    try {
        $p = Invoke-RestMethod -Uri "$base/project/$s" -Headers $ua
        if ($p.loaders -contains 'forge') {
            $v = Invoke-RestMethod -Uri "$base/project/$s/version?loaders=$lo&game_versions=$gv" -Headers $ua
        } else {
            $v = Invoke-RestMethod -Uri "$base/project/$s/version?game_versions=$gv" -Headers $ua
        }
        $vers[$s] = @($v | ForEach-Object {
            [pscustomobject]@{
                version_number = $_.version_number; version_type = $_.version_type; date_published = $_.date_published
                loaders = $_.loaders
                files = @($_.files | ForEach-Object { [pscustomobject]@{ filename = $_.filename; size = $_.size; url = $_.url; primary = $_.primary } })
                dependencies = $_.dependencies
            }
        })
        $first = $v | Select-Object -First 1
        $rows += [pscustomobject]@{
            slug = $s; title = $p.title; type = $p.project_type; client = $p.client_side; server = $p.server_side
            downloads = $p.downloads; updated = $p.updated.Substring(0, 10)
            n1201 = @($v).Count
            latest = if ($first) { $first.version_number } else { '' }
            latestDate = if ($first) { $first.date_published.Substring(0, 10) } else { '' }
            latestType = if ($first) { $first.version_type } else { '' }
            latestFile = if ($first) { ($first.files | Select-Object -First 1).filename } else { '' }
        }
    } catch {
        $rows += [pscustomobject]@{ slug = $s; title = 'ERR ' + $_.Exception.Message }
    }
    Start-Sleep -Milliseconds 250
}
$rows | Format-Table -AutoSize | Out-String -Width 250
$vers | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $Out 'versions2.json') -Encoding utf8

$qs = @('Ice and Fire Community Edition', 'Ice and Fire', 'Almost Unified', 'zombie awareness', 'wither storm')
foreach ($q in $qs) {
    $facets = [uri]::EscapeDataString('[["versions:1.20.1"],["categories:forge"]]')
    $r = Invoke-RestMethod -Uri "$base/search?query=$([uri]::EscapeDataString($q))&facets=$facets&limit=6" -Headers $ua
    Write-Output ("--- search: " + $q)
    $r.hits | ForEach-Object { "{0} ({1}) dl={2} upd={3}" -f $_.title, $_.slug, $_.downloads, $_.date_modified.Substring(0, 10) }
}
