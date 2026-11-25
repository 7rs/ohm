param([string]$Data)
$ErrorActionPreference = 'Stop'
$ua = @{ 'User-Agent' = 'shader-research-script/1.0' }
$a = (Get-Content (Join-Path $Data 'A_user_filter.json') -Raw | ConvertFrom-Json) | Where-Object { $_.downloads -ge 100000 }
$ids = @($a | ForEach-Object { $_.project_id })
$projects = @()
for ($i = 0; $i -lt $ids.Count; $i += 20) {
    $chunk = $ids[$i..([Math]::Min($i + 19, $ids.Count - 1))]
    $q = [uri]::EscapeDataString(('[' + (($chunk | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']'))
    $projects += Invoke-RestMethod -Uri "https://api.modrinth.com/v2/projects?ids=$q" -Headers $ua
    Start-Sleep -Milliseconds 300
}
$projects | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $Data 'projects.json') -Encoding utf8
Write-Output "projects: $($projects.Count)"
$vers = @{}
foreach ($p in $projects) {
    $gv = [uri]::EscapeDataString('["1.20.1"]')
    $ld = [uri]::EscapeDataString('["iris"]')
    $v = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$($p.id)/version?loaders=$ld&game_versions=$gv" -Headers $ua
    $vers[$p.slug] = @($v | ForEach-Object {
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
$vers | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $Data 'versions.json') -Encoding utf8
Write-Output "versions fetched for $($vers.Count) projects"
