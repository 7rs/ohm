param([string]$Meta, [string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
New-Item -ItemType Directory -Force $Out | Out-Null
$versions = Get-Content (Join-Path $Meta 'versions2.json') -Raw | ConvertFrom-Json
$skip = @('true-ending-ender-dragon-music', 'pehkui', 'spawn-animations-compats')
foreach ($p in $versions.PSObject.Properties) {
    if ($skip -contains $p.Name) { continue }
    $v = @($p.Value)[0]
    if (-not $v) { continue }
    $f = @($v.files) | Select-Object -First 1
    $dest = Join-Path $Out $f.filename
    if (Test-Path -LiteralPath $dest) { continue }
    try {
        $wc = New-Object Net.WebClient
        $wc.Headers.Add('User-Agent', 'packwiz-pack-review/1.0')
        $wc.DownloadFile($f.url, $dest)
        Write-Output ("ok " + $p.Name + " " + $f.filename)
    } catch { Write-Output ("FAIL " + $p.Name + " " + $_.Exception.Message) }
}
$gv = [uri]::EscapeDataString('["1.20.1"]'); $lo = [uri]::EscapeDataString('["forge"]')
foreach ($s in 'iceandfire-ce', 'jupiter', 'uranus') {
    $v = Invoke-RestMethod -Uri "https://api.modrinth.com/v2/project/$s/version?loaders=$lo&game_versions=$gv" -Headers $ua
    $f = @($v[0].files) | Select-Object -First 1
    $dest = Join-Path $Out $f.filename
    if (Test-Path -LiteralPath $dest) { continue }
    try {
        $wc = New-Object Net.WebClient
        $wc.Headers.Add('User-Agent', 'packwiz-pack-review/1.0')
        $wc.DownloadFile($f.url, $dest)
        Write-Output ("ok " + $s + " " + $v[0].version_number + " " + $f.filename + " deps=" + (($v[0].dependencies | ForEach-Object { $_.dependency_type + ':' + $_.project_id }) -join ','))
    } catch { Write-Output ("FAIL " + $s + " " + $_.Exception.Message) }
}
