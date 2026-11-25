param([string]$Meta, [string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
New-Item -ItemType Directory -Force $Out | Out-Null
$versions = Get-Content (Join-Path $Meta 'versions.json') -Raw | ConvertFrom-Json
foreach ($p in $versions.PSObject.Properties) {
    $vs = @($p.Value | Where-Object { $_.loaders -contains 'forge' })
    if ($vs.Count -eq 0) { Write-Output ("no forge version: " + $p.Name); continue }
    $v = $vs[0]
    $f = $v.files | Where-Object { $_.primary } | Select-Object -First 1
    if (-not $f) { $f = $v.files[0] }
    $dest = Join-Path $Out $f.filename
    if (Test-Path -LiteralPath $dest) { continue }
    try {
        Invoke-WebRequest -Uri $f.url -OutFile $dest -UseBasicParsing -Headers @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
        Write-Output ("ok " + $p.Name + " " + $f.filename)
    } catch {
        Write-Output ("FAIL " + $p.Name + " " + $_.Exception.Message)
    }
}
Write-Output ("jars: " + (Get-ChildItem $Out -Filter '*.jar').Count)
