param([string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'pack-review/1.0'; 'Accept' = 'application/vnd.github+json' }
$repos = [ordered]@{
    'champions'      = 'CrychicTeam/Champions'
    'celestials'     = 'CorgiTaco/Enhanced-Celestials'
    'simpleenemy'    = 'NekoYuni/Simple-Enemy-Mod-Public'
    'combinedarms'   = 'NeoAlive/tacz-simple-enemies-vehicular-warfare'
    'clanginghowl'   = 'Polarice3/ClangingHowl'
}
$lines = New-Object System.Collections.Generic.List[string]
foreach ($k in $repos.Keys) {
    $repo = $repos[$k]
    foreach ($page in 1, 2) {
        try {
            $res = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/issues?state=all&per_page=100&page=$page&sort=updated" -Headers $ua
        } catch {
            $lines.Add("## $k | $repo | FAIL $($_.Exception.Message)")
            break
        }
        if (-not $res) { break }
        foreach ($i in $res) {
            if ($i.pull_request) { continue }
            $body = ''
            if ($i.body) { $body = ($i.body -replace '\s+', ' ') }
            if ($body.Length -gt 300) { $body = $body.Substring(0, 300) }
            $lines.Add(("{0}`t#{1}`t{2}`t{3}`t{4}`t{5}" -f $k, $i.number, $i.state, $i.created_at.Substring(0, 10), $i.title, $body))
        }
        if ($res.Count -lt 100) { break }
    }
}
$lines | Out-File -Encoding utf8 $Out
Write-Output ("rows: " + $lines.Count)
