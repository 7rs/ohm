param([string]$Out, [string]$Spec)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0'; 'Accept' = 'application/vnd.github+json' }
$items = $Spec.Split(';') | ForEach-Object { $p = $_.Split('#'); , @($p[0], [int]$p[1]) }
$lines = New-Object System.Collections.Generic.List[string]
foreach ($it in $items) {
    $repo = $it[0]; $n = $it[1]
    try {
        $i = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/issues/$n" -Headers $ua
        $lines.Add("##### $repo #$n [$($i.state)] $($i.title) | comments=$($i.comments) | created=$($i.created_at.Substring(0,10)) updated=$($i.updated_at.Substring(0,10)) | labels=$((@($i.labels | ForEach-Object { $_.name })) -join ',')")
        $b = if ($i.body) { $i.body -replace '\r', '' } else { '' }
        $lines.Add($b.Substring(0, [Math]::Min(1100, $b.Length)))
        if ($i.comments -gt 0) {
            $c = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/issues/$n/comments?per_page=100" -Headers $ua
            foreach ($cm in ($c | Select-Object -Last 3)) {
                $cb = ($cm.body -replace '\r', '')
                $lines.Add("  >> comment by $($cm.user.login) $($cm.created_at.Substring(0,10)): " + $cb.Substring(0, [Math]::Min(600, $cb.Length)))
            }
        }
    } catch {
        $lines.Add("##### $repo #$n ERR " + $_.Exception.Message)
    }
    Start-Sleep -Milliseconds 500
}
[IO.File]::WriteAllLines($Out, $lines, (New-Object Text.UTF8Encoding($false)))
Write-Output "done $($lines.Count)"
