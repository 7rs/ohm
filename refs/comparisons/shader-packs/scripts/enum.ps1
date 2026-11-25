param([string]$Out)
$ErrorActionPreference = 'Stop'
$ua = @{ 'User-Agent' = 'shader-research-script/1.0' }
function Get-Hits($facets) {
    $all = @()
    $offset = 0
    while ($true) {
        $f = [uri]::EscapeDataString($facets)
        $u = "https://api.modrinth.com/v2/search?facets=$f&limit=100&offset=$offset&index=downloads"
        $r = Invoke-RestMethod -Uri $u -Headers $ua
        $all += $r.hits
        $offset += 100
        if ($offset -ge $r.total_hits) { break }
        Start-Sleep -Milliseconds 300
    }
    return $all
}
$sets = @{
    'A_user_filter'   = '[["project_type:shader"],["versions:1.20.1"],["categories:iris"]]'
    'B_any_loader_1201' = '[["project_type:shader"],["versions:1.20.1"]]'
    'C_iris_any_version' = '[["project_type:shader"],["categories:iris"]]'
    'D_all_shaders'   = '[["project_type:shader"]]'
}
foreach ($k in $sets.Keys) {
    $h = Get-Hits $sets[$k]
    $h | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $Out "$k.json") -Encoding utf8
    Write-Output ("{0}: {1} hits, {2} with >=100000 downloads" -f $k, $h.Count, ($h | Where-Object { $_.downloads -ge 100000 }).Count)
}
