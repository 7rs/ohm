param([string]$ModsDir, [string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
New-Item -ItemType Directory -Force $Out | Out-Null
foreach ($f in Get-ChildItem $ModsDir -Filter '*.pw.toml') {
    $t = Get-Content $f.FullName -Raw
    if ($t -notmatch 'metadata:curseforge') { continue }
    $fn = [regex]::Match($t, '(?m)^filename\s*=\s*"(.*)"').Groups[1].Value
    $id = [int64][regex]::Match($t, '(?m)^file-id\s*=\s*(\d+)').Groups[1].Value
    $url = "https://edge.forgecdn.net/files/$([math]::Floor($id / 1000))/$($id % 1000)/$([uri]::EscapeDataString($fn))"
    $dest = Join-Path $Out ($fn -replace '[\[\]]', '_')
    try {
        $wc = New-Object Net.WebClient
        $wc.Headers.Add('User-Agent', 'packwiz-pack-review/1.0')
        $wc.DownloadFile($url, $dest)
        Write-Output ("ok " + $fn)
    } catch {
        Write-Output ("FAIL " + $fn + " " + $_.Exception.Message)
    }
}
