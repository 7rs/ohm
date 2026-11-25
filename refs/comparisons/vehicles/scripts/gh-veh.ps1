param([string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0'; 'Accept' = 'application/vnd.github+json' }
$repos = [ordered]@{
    'valkyrienskies' = @{ repo = 'ValkyrienSkies/Valkyrien-Skies-2'; kw = @('Oculus', 'Embeddium', 'Distant Horizons', 'Colorwheel', 'Entity Culling', 'ModernFix', 'Create 6', 'TaCZ', 'Superb Warfare', 'shaders') }
    'railways'       = @{ repo = 'Layers-of-Railways/Railway'; kw = @('Oculus', 'Colorwheel', 'Distant Horizons', 'Embeddium', 'Create 6', 'CreateBetterFPS', 'Valkyrien') }
    'aircraft'       = @{ repo = 'Luke100000/ImmersiveAircraft'; kw = @('Oculus', 'Embeddium', 'Distant Horizons', 'Valkyrien', 'Immersive Optimization', 'Entity Culling', 'Superb Warfare') }
    'mts'            = @{ repo = 'DonBruce64/MinecraftTransportSimulator'; kw = @('Oculus', 'Embeddium', 'shaders', 'Distant Horizons', '1.20.1', 'TaCZ') }
    'smallships'     = @{ repo = 'talhanation/smallships'; kw = @('Oculus', 'Embeddium', 'Valkyrien', 'Distant Horizons', 'Create') }
}
$lines = New-Object System.Collections.Generic.List[string]
foreach ($k in $repos.Keys) {
    $r = $repos[$k]
    foreach ($kw in $r.kw) {
        $q = [uri]::EscapeDataString("repo:$($r.repo) `"$kw`"")
        try {
            $res = Invoke-RestMethod -Uri "https://api.github.com/search/issues?q=$q&per_page=6&sort=updated" -Headers $ua
            $lines.Add("## $k | $($r.repo) | $kw | total=$($res.total_count)")
            foreach ($i in $res.items) {
                $lines.Add(("  #{0} [{1}] {2} ({3}) comments={4}" -f $i.number, $i.state, $i.title, $i.updated_at.Substring(0, 10), $i.comments))
            }
        } catch {
            $lines.Add("## $k | $kw | ERR " + $_.Exception.Message)
            Start-Sleep -Seconds 30
        }
        Start-Sleep -Seconds 7
        [IO.File]::WriteAllLines($Out, $lines, (New-Object Text.UTF8Encoding($false)))
    }
}
[IO.File]::WriteAllLines($Out, $lines, (New-Object Text.UTF8Encoding($false)))
Write-Output "done $($lines.Count) lines"
