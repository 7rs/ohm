param([string]$Data, [string]$Packs)
$ErrorActionPreference = 'Continue'
$ua = @{ 'User-Agent' = 'shader-research-script/1.0' }
$v = Get-Content (Join-Path $Data 'versions.json') -Raw | ConvertFrom-Json
foreach ($pp in $v.PSObject.Properties) {
    $slug = $pp.Name
    $latest = @($pp.Value) | Sort-Object date_published -Descending | Select-Object -First 1
    $f = @($latest.files) | Where-Object { $_.primary } | Select-Object -First 1
    if (-not $f) { $f = @($latest.files)[0] }
    $dir = Join-Path $Packs $slug
    New-Item -ItemType Directory -Force $dir | Out-Null
    $dest = Join-Path $dir 'pack.zip'
    if ((Test-Path $dest) -and ((Get-Item $dest).Length -eq $f.size)) { Write-Output "skip $slug"; continue }
    try {
        Invoke-WebRequest -Uri $f.url -Headers $ua -OutFile $dest -UseBasicParsing
        Set-Content -Path (Join-Path $dir 'source.txt') -Value ("{0}`n{1}`n{2}`n{3}" -f $f.filename, $f.url, $latest.version_number, $latest.date_published) -Encoding utf8
        Write-Output ("ok {0} {1}" -f $slug, $f.size)
    } catch {
        Write-Output ("FAIL {0} {1}" -f $slug, $_.Exception.Message)
    }
}
Write-Output 'done'
