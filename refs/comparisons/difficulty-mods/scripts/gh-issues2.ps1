param([string]$Out, [string]$Repos)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0'; 'Accept' = 'application/vnd.github+json' }
New-Item -ItemType Directory -Force $Out | Out-Null
$kw = 'tacz|timeless|oculus|iris|embeddium|sodium|distant horizons|flywheel|zombie awareness|simple enemy|ai improvements|immersive optimization|1\.20\.1'
$lines = New-Object System.Collections.Generic.List[string]
foreach ($ln in (Get-Content $Repos | Where-Object { $_ -match '/' })) {
    $slug, $repo = $ln.Split('=', 2) | ForEach-Object { $_.Trim() }
    try {
        $items = @()
        $page = 1
        while ($page -le 2) {
            $res = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/issues?state=all&per_page=100&page=$page&sort=updated&direction=desc" -Headers $ua
            $got = @($res | ForEach-Object { $_ })
            if ($got.Count -eq 0) { break }
            $items += $got
            if ($got.Count -lt 100) { break }
            $page++
        }
        $iss = @($items | Where-Object { -not $_.pull_request })
        $open = @($iss | Where-Object { $_.state -eq 'open' })
        $lines.Add("## $slug | $repo | listed=$($iss.Count) open=$($open.Count) newest_update=$(if ($iss.Count) { $iss[0].updated_at.Substring(0,10) } else { 'none' })")
        $iss | ConvertTo-Json -Depth 3 | Set-Content (Join-Path $Out ($slug + '.json')) -Encoding utf8
        foreach ($i in $iss) {
            $t = ($i.title + ' ' + $i.body)
            if ($t -match $kw -and ($i.title -match $kw -or $i.state -eq 'open')) {
                $m = [regex]::Matches($t, $kw, 'IgnoreCase') | ForEach-Object { $_.Value.ToLower() } | Sort-Object -Unique
                $lines.Add(("  #{0} [{1}] {2} ({3}) kw={4}" -f $i.number, $i.state, $i.title, $i.updated_at.Substring(0, 10), ($m -join ',')))
            }
        }
    } catch {
        $lines.Add("## $slug | $repo | ERR " + $_.Exception.Message)
    }
    Start-Sleep -Milliseconds 600
}
[IO.File]::WriteAllLines((Join-Path $Out 'digest.md'), $lines, (New-Object Text.UTF8Encoding($false)))
Write-Output "done $($lines.Count) lines"
