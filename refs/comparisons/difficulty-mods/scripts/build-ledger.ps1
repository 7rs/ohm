param([string]$Scratch, [string]$Dir)
$ErrorActionPreference = 'Stop'
$c = Import-Csv (Join-Path $Scratch 'cands\cands.csv') | Where-Object { $_.title -ne 'NOT FOUND' }
$sum = @{}
foreach ($r in (Import-Csv (Join-Path $Scratch 'cand_summary.csv'))) { $sum[$r.file] = $r }
$status = @{}
foreach ($ln in (Get-Content (Join-Path $Dir 'scripts\status.txt') -Encoding utf8 | Where-Object { $_ -match '\|' })) {
    $p = $ln.Split('|', 3); $status[$p[0]] = @{ s = $p[1]; r = $p[2] }
}
$shared = @{}
$cur = ''
foreach ($l in (Get-Content (Join-Path $Scratch 'targets_shared.txt') -Encoding utf8)) {
    if ($l -match '^=== (.+?) targets=(\d+)') { $cur = $Matches[1] }
    elseif ($l -match 'same methods are also hooked by installed mods: (\d+)') { $shared[$cur] = $Matches[1] }
}
$ow = @{}
$cur = ''
foreach ($l in (Get-Content (Join-Path $Scratch 'conflicts_hard.txt') -Encoding utf8)) {
    if ($l -match '^=== (.+?)\s+hard conflicts \(same exclusive hook on same call\): (\d+)\s+overwrite pairs: (\d+)') { $ow[$Matches[1]] = @{ h = $Matches[2]; o = $Matches[3] } }
}
$rows = foreach ($r in $c) {
    $j = $sum[$r.filename]
    $st = $status[$r.slug]
    $deps = (($r.deps -split ';') | Where-Object { $_ -match '^required:' } | Sort-Object -Unique) -join ';'
    [pscustomobject]@{
        axis = $r.axis; slug = $r.slug; title = $r.title; source = 'modrinth'
        downloads = $r.downloads; forge_builds = $r.forge_builds
        picked = $r.picked; picked_type = $r.picked_type; picked_date = $r.picked_date
        newest_date = $r.newest_date; size_mb = [math]::Round([int64]$r.size / 1MB, 1)
        server = $r.server; client = $r.client
        required_modrinth = $deps
        loaders_in_jar = if ($j) { $j.loaders } else { '' }
        required_not_installed = if ($j) { $j.required_not_installed } else { '' }
        mixin_classes = if ($j) { $j.mixin_classes } else { '' }
        shared_hook_classes = if ($shared.ContainsKey($r.filename)) { $shared[$r.filename] } else { '' }
        hard_conflicts = if ($ow.ContainsKey($r.filename)) { $ow[$r.filename].h } else { '' }
        overwrite_pairs = if ($ow.ContainsKey($r.filename)) { $ow[$r.filename].o } else { '' }
        tacz_string_hits = if ($j) { $j.tacz_refs } else { '' }
        repository = $r.source
        status = if ($st) { $st.s } else { 'reviewed' }
        reason = if ($st) { $st.r } else { '' }
    }
}
$rows | Export-Csv (Join-Path $Dir 'products.csv') -NoTypeInformation -Encoding utf8
Write-Output ("products=" + $rows.Count + " finalists=" + (($rows | Where-Object { $_.status -eq 'finalist' }).Count) + " excluded=" + (($rows | Where-Object { $_.status -eq 'excluded' }).Count) + " missing_status=" + (($rows | Where-Object { -not $_.reason }).Count))
