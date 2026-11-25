param([string]$Out)
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
$base = 'https://api.modrinth.com/v2'
$facets = [uri]::EscapeDataString('[["project_type:mod"],["versions:1.20.1"],["categories:forge"]]')
$q = @{
    survival = @('thirst', 'temperature', 'survival', 'hunger', 'stamina', 'injury', 'bleeding', 'body part health', 'hardcore', 'sanity', 'fatigue', 'disease', 'seasons', 'nutrition', 'realism', 'wounds', 'death penalty', 'fear', 'parasite', 'infection')
    scaling = @('difficulty', 'scaling', 'mob level', 'mob health', 'mob attributes', 'progression', 'stages', 'dynamic difficulty', 'boss scaling', 'distance from spawn', 'night difficulty', 'elite mobs', 'affixes', 'mob upgrade', 'wave')
    content = @('boss', 'dungeon', 'mini boss', 'hostile mobs', 'mutant', 'raid', 'invasion', 'nightmare', 'apocalypse', 'siege', 'monsters', 'challenge', 'dragon', 'cataclysm', 'horde')
    enemy = @('mob variants', 'new monsters', 'zombie', 'skeleton', 'illager', 'undead', 'soldier', 'mercenary', 'enemy ai', 'smart mobs', 'creeper', 'hostile ai', 'faction', 'bandit', 'pirate')
}
New-Item -ItemType Directory -Force $Out | Out-Null
$rows = New-Object System.Collections.Generic.List[object]
foreach ($axis in $q.Keys) {
    foreach ($term in $q[$axis]) {
        $enc = [uri]::EscapeDataString($term)
        $uri = "$base/search?query=$enc&facets=$facets&limit=40"
        try {
            $r = Invoke-RestMethod -Uri $uri -Headers $ua
        } catch {
            Write-Output ("FAIL " + $term + " " + $_.Exception.Message)
            continue
        }
        $rank = 0
        foreach ($h in $r.hits) {
            $rank++
            $rows.Add([pscustomobject]@{
                axis = $axis; query = $term; rank = $rank; slug = $h.slug; title = $h.title
                downloads = $h.downloads; follows = $h.follows; modified = $h.date_modified.Substring(0, 10)
                client = $h.client_side; server = $h.server_side
                categories = ($h.display_categories -join ';')
                description = ($h.description -replace '[\r\n,]', ' ')
            })
        }
        Start-Sleep -Milliseconds 300
    }
}
$rows | Export-Csv (Join-Path $Out 'search_raw.csv') -NoTypeInformation -Encoding utf8
Write-Output ("rows=" + $rows.Count + " unique=" + (($rows | Select-Object -ExpandProperty slug -Unique).Count))
