param([string]$ModsDir, [string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
New-Item -ItemType Directory -Force $Out | Out-Null
$skipped = @()
foreach ($f in Get-ChildItem $ModsDir -Filter '*.pw.toml') {
    $t = Get-Content $f.FullName -Raw
    $fn = [regex]::Match($t, '(?m)^filename\s*=\s*"(.*)"').Groups[1].Value
    $url = [regex]::Match($t, '(?m)^url\s*=\s*"(.*)"').Groups[1].Value
    if (-not $url) { $skipped += $f.Name; continue }
    $dest = Join-Path $Out $fn
    if (Test-Path -LiteralPath $dest) { continue }
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -Headers @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
    } catch {
        Write-Output ("FAIL " + $f.Name + " " + $_.Exception.Message)
    }
}
Write-Output ("skipped (no url): " + ($skipped -join ', '))
Write-Output ("jars: " + (Get-ChildItem $Out -Filter '*.jar').Count)
