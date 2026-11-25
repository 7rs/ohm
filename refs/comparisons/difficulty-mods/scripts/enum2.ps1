param([string]$Out)
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
$base = 'https://api.modrinth.com/v2'
$facets = [uri]::EscapeDataString('[["project_type:mod"],["versions:1.20.1"],["categories:forge"]]')
$q = @{
    survival = @('first aid', 'dehydration', 'stamina bar', 'broken bones', 'vitality', 'food poisoning', 'sleep', 'darkness', 'inventory weight', 'encumbrance', 'hunger overhaul', 'cold', 'heat', 'hydration', 'natural regeneration', 'health regeneration', 'fall damage', 'bandage', 'medical', 'radiation')
    scaling = @('level', 'mobs level up', 'player level scaling', 'day count', 'lunar', 'blood moon', 'evolve', 'adaptive', 'bounty', 'rank', 'modifiers', 'traits', 'mob equipment', 'mob armor', 'mob spawner', 'infernal', 'champion', 'attribute', 'spawn rate', 'monster spawning')
    content = @('mowzie', 'born in chaos', 'alex mobs', 'sons of sins', 'aquamirae', 'souls-like', 'eldritch', 'abyss', 'void', 'nether bosses', 'end bosses', 'ice and fire', 'goety', 'ancient', 'trial', 'arena', 'wither', 'structure mobs', 'legendary', 'raid boss')
    enemy = @('tacz', 'gun enemies', 'npc', 'armed', 'military', 'terrorist', 'zombie apocalypse', 'tactical', 'squad', 'patrol', 'raider', 'cultist', 'vampire', 'werewolf', 'goblin', 'orc', 'giant', 'ranged mobs', 'combat ai', 'monster behavior')
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
$rows | Export-Csv (Join-Path $Out 'search_raw2.csv') -NoTypeInformation -Encoding utf8
Write-Output ("rows=" + $rows.Count + " unique=" + (($rows | Select-Object -ExpandProperty slug -Unique).Count))
