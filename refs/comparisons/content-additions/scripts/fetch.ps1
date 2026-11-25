param([string]$Out)
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
$base = 'https://api.modrinth.com/v2'
$slugs = @(
    'almost-unify-everything', 'vanillabackport', 'spawn-animations', '3dskinlayers',
    'zombie-awareness', 'endrem', 'true-ending', 'crackers-wither-storm-mod', 'deeperdarker',
    'waystones', 'ice-and-fire-dragons', 'touhou-little-maid',
    'mekanism', 'mekanism-generators', 'createaddition', 'ae2',
    'irons-spells-n-spellbooks', 'ars-nouveau', 'botania'
)
New-Item -ItemType Directory -Force $Out | Out-Null
$gv = [uri]::EscapeDataString('["1.20.1"]')
$projects = @()
$versions = @{}
$depIds = New-Object System.Collections.Generic.HashSet[string]
foreach ($s in $slugs) {
    $p = Invoke-RestMethod -Uri "$base/project/$s" -Headers $ua
    $projects += $p
    if ($p.loaders -contains 'forge') {
        $lo = [uri]::EscapeDataString('["forge"]')
        $v = Invoke-RestMethod -Uri "$base/project/$s/version?loaders=$lo&game_versions=$gv" -Headers $ua
    } else {
        $v = Invoke-RestMethod -Uri "$base/project/$s/version?game_versions=$gv" -Headers $ua
    }
    $versions[$s] = @($v | ForEach-Object {
        foreach ($d in $_.dependencies) { if ($d.project_id) { [void]$depIds.Add($d.project_id) } }
        [pscustomobject]@{
            id = $_.id; version_number = $_.version_number; name = $_.name; version_type = $_.version_type
            date_published = $_.date_published; downloads = $_.downloads
            game_versions = $_.game_versions; loaders = $_.loaders
            changelog = $_.changelog
            files = @($_.files | ForEach-Object { [pscustomobject]@{ filename = $_.filename; size = $_.size; url = $_.url; primary = $_.primary } })
            dependencies = $_.dependencies
        }
    })
    Start-Sleep -Milliseconds 250
}
$projects | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $Out 'projects.json') -Encoding utf8
$versions | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $Out 'versions.json') -Encoding utf8
$ids = @($depIds)
$deps = @()
for ($i = 0; $i -lt $ids.Count; $i += 50) {
    $chunk = $ids[$i..([Math]::Min($i + 49, $ids.Count - 1))]
    $q = [uri]::EscapeDataString(('[' + (($chunk | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']'))
    $deps += Invoke-RestMethod -Uri "$base/projects?ids=$q" -Headers $ua
    Start-Sleep -Milliseconds 250
}
$deps | Select-Object id, slug, title | ConvertTo-Json -Depth 3 | Set-Content (Join-Path $Out 'deps.json') -Encoding utf8
Write-Output "projects=$($projects.Count) versions=$($versions.Count) deps=$($deps.Count)"
