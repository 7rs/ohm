param([string]$Pack, [string]$Out)
$ProgressPreference = 'SilentlyContinue'
New-Item -ItemType Directory -Force $Out | Out-Null
$log = Join-Path (Split-Path $Out -Parent) 'get-jars.log'
'' | Set-Content $log
foreach ($f in Get-ChildItem (Join-Path $Pack 'mods') -Filter *.pw.toml) {
    $t = Get-Content $f.FullName -Raw
    $slug = $f.Name -replace '\.pw\.toml$', ''
    $fn = if ($t -match '(?m)^filename\s*=\s*"([^"]+)"') { $Matches[1] } else { '' }
    $url = ''
    if ($t -match '(?m)^url\s*=\s*"([^"]+)"') { $url = $Matches[1] }
    elseif ($t -match 'file-id\s*=\s*(\d+)') {
        $id = [int64]$Matches[1]
        $url = 'https://mediafilez.forgecdn.net/files/{0}/{1}/{2}' -f [math]::Floor($id / 1000), ($id % 1000), [uri]::EscapeDataString($fn)
    }
    if (-not $url) { "$slug NOURL" | Add-Content $log; continue }
    $dest = Join-Path $Out ($slug + '__' + ($fn -replace '[^\w\.\-\+]', '_'))
    if (Test-Path $dest) { "$slug SKIP" | Add-Content $log; continue }
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -Headers @{ 'User-Agent' = 'ohm-pack-research/1.0' }
        "$slug OK $((Get-Item $dest).Length)" | Add-Content $log
    } catch {
        "$slug FAIL $url $($_.Exception.Message)" | Add-Content $log
    }
}
'DONE' | Add-Content $log
