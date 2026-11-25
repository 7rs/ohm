param([string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'pack-review/1.0' }
New-Item -ItemType Directory -Force $Out | Out-Null
$slugs = @(
    'champions-unofficial', 'architectury-api',
    'enhanced-celestials', 'enhanced-celestials-2-core', 'enhanced-celestials-2-default-lunar-events', 'data-anchor', 'corgilib',
    'tacz-npcs', 'simple-enemy', 'tacz-combined-arms'
)
$lv = [uri]::EscapeDataString('["forge"]')
$gv = [uri]::EscapeDataString('["1.20.1"]')
foreach ($s in $slugs) {
    $v = (Invoke-RestMethod "https://api.modrinth.com/v2/project/$s/version?loaders=$lv&game_versions=$gv" -Headers $ua)[0]
    $f = $v.files | Where-Object { $_.primary } | Select-Object -First 1
    if (-not $f) { $f = $v.files[0] }
    $dest = Join-Path $Out $f.filename
    if (-not (Test-Path -LiteralPath $dest)) { Invoke-WebRequest $f.url -OutFile $dest -UseBasicParsing -Headers $ua }
    $req = ($v.dependencies | Where-Object { $_.dependency_type -eq 'required' } | ForEach-Object { $_.project_id }) -join ','
    $opt = ($v.dependencies | Where-Object { $_.dependency_type -eq 'optional' } | ForEach-Object { $_.project_id }) -join ','
    $inc = ($v.dependencies | Where-Object { $_.dependency_type -eq 'incompatible' } | ForEach-Object { $_.project_id }) -join ','
    Write-Output ("{0}`t{1}`t{2}`t{3}`t{4}`treq={5}`topt={6}`tinc={7}" -f $s, $v.version_number, $v.version_type, $v.date_published.Substring(0, 10), $f.filename, $req, $opt, $inc)
}
