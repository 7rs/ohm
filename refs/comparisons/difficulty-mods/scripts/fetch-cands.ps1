param([string]$Slugs, [string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
$base = 'https://api.modrinth.com/v2'
New-Item -ItemType Directory -Force $Out | Out-Null
$gv = [uri]::EscapeDataString('["1.20.1"]')
$lo = [uri]::EscapeDataString('["forge"]')
$lines = Get-Content $Slugs | Where-Object { $_ -match ',' }
$rows = New-Object System.Collections.Generic.List[object]
$depIds = New-Object System.Collections.Generic.HashSet[string]
$meta = @{}
foreach ($ln in $lines) {
    $axis, $slug = $ln.Split(',', 2) | ForEach-Object { $_.Trim() }
    try {
        $p = Invoke-RestMethod -Uri "$base/project/$slug" -Headers $ua
        $raw = Invoke-RestMethod -Uri "$base/project/$slug/version?loaders=$lo&game_versions=$gv" -Headers $ua
        $v = $raw | ForEach-Object { $_ }
    } catch {
        Write-Output ("FAIL $slug " + $_.Exception.Message)
        $rows.Add([pscustomobject]@{ axis = $axis; slug = $slug; title = 'NOT FOUND' })
        continue
    }
    $v = @($v | Sort-Object date_published -Descending)
    $rel = @($v | Where-Object { $_.version_type -eq 'release' })
    $pick = if ($rel.Count -gt 0) { $rel[0] } elseif ($v.Count -gt 0) { $v[0] } else { $null }
    $newest = if ($v.Count -gt 0) { $v[0] } else { $null }
    if ($pick) {
        foreach ($d in $pick.dependencies) { if ($d.project_id) { [void]$depIds.Add($d.project_id) } }
    }
    $f = if ($pick) { $pick.files | Where-Object { $_.primary } | Select-Object -First 1 } else { $null }
    if ($pick -and -not $f) { $f = $pick.files | Select-Object -First 1 }
    $meta[$slug] = [pscustomobject]@{ project = $p; picked = $pick; newest = $newest; count = $v.Count }
    $rows.Add([pscustomobject]@{
        axis = $axis; slug = $slug; title = $p.title
        downloads = $p.downloads; follows = $p.followers; project_updated = $p.updated.Substring(0, 10)
        client = $p.client_side; server = $p.server_side
        forge_builds = $v.Count
        picked = if ($pick) { $pick.version_number } else { '' }
        picked_type = if ($pick) { $pick.version_type } else { '' }
        picked_date = if ($pick) { $pick.date_published.Substring(0, 10) } else { '' }
        newest = if ($newest) { $newest.version_number } else { '' }
        newest_type = if ($newest) { $newest.version_type } else { '' }
        newest_date = if ($newest) { $newest.date_published.Substring(0, 10) } else { '' }
        size = if ($f) { $f.size } else { 0 }
        filename = if ($f) { $f.filename } else { '' }
        url = if ($f) { $f.url } else { '' }
        source = $p.source_url; issues = $p.issues_url
        dep_ids = if ($pick) { (($pick.dependencies | Where-Object { $_.project_id } | ForEach-Object { $_.dependency_type + ':' + $_.project_id }) -join ';') } else { '' }
    })
    Start-Sleep -Milliseconds 200
}
$ids = @($depIds)
$map = @{}
for ($i = 0; $i -lt $ids.Count; $i += 50) {
    $chunk = $ids[$i..([Math]::Min($i + 49, $ids.Count - 1))]
    $q = [uri]::EscapeDataString(('[' + (($chunk | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']'))
    foreach ($d in (Invoke-RestMethod -Uri "$base/projects?ids=$q" -Headers $ua)) { $map[$d.id] = $d.slug }
    Start-Sleep -Milliseconds 200
}
foreach ($r in $rows) {
    if ($r.PSObject.Properties.Name -contains 'dep_ids' -and $r.dep_ids) {
        $r | Add-Member -NotePropertyName deps -NotePropertyValue (($r.dep_ids.Split(';') | ForEach-Object { $t, $id = $_.Split(':'); $t + ':' + $(if ($map.ContainsKey($id)) { $map[$id] } else { $id }) }) -join ';') -Force
    }
}
$rows | Select-Object * -ExcludeProperty dep_ids | Export-Csv (Join-Path $Out 'cands.csv') -NoTypeInformation -Encoding utf8
$meta | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $Out 'cands_meta.json') -Encoding utf8
Write-Output ("rows=" + $rows.Count)
