param([string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0'; 'Accept' = 'application/vnd.github+json' }
$items = @(
    @('tr7zw/3d-skin-layers', 165), @('tr7zw/3d-skin-layers', 303),
    @('AlexModGuy/Ice_and_Fire', 5416), @('AlexModGuy/Ice_and_Fire', 5592),
    @('nonamecrackers2/crackers-wither-storm-mod', 2505), @('nonamecrackers2/crackers-wither-storm-mod', 2293),
    @('AppliedEnergistics/Applied-Energistics-2', 8772),
    @('mrh0/createaddition', 1063), @('mrh0/createaddition', 899),
    @('Tschipcraft/spawnanimations', 33), @('Tschipcraft/spawnanimations', 53),
    @('ItsBlackGear/VanillaBackport', 89),
    @('VazkiiMods/Botania', 3951),
    @('TartaricAcid/TouhouLittleMaid', 1146),
    @('KyaniteMods/DeeperAndDarker', 441),
    @('mekanism/Mekanism', 8609)
)
$lines = New-Object System.Collections.Generic.List[string]
foreach ($it in $items) {
    $repo = $it[0]; $n = $it[1]
    try {
        $i = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/issues/$n" -Headers $ua
        $lines.Add("##### $repo #$n [$($i.state)] $($i.title) | comments=$($i.comments) | created=$($i.created_at.Substring(0,10)) updated=$($i.updated_at.Substring(0,10)) | labels=$((@($i.labels | ForEach-Object { $_.name })) -join ',')")
        $b = if ($i.body) { $i.body -replace '\r', '' } else { '' }
        $lines.Add($b.Substring(0, [Math]::Min(900, $b.Length)))
        if ($i.comments -gt 0) {
            $c = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/issues/$n/comments?per_page=100" -Headers $ua
            foreach ($cm in ($c | Select-Object -Last 3)) {
                $cb = ($cm.body -replace '\r', '')
                $lines.Add("  >> comment by $($cm.user.login) $($cm.created_at.Substring(0,10)): " + $cb.Substring(0, [Math]::Min(500, $cb.Length)))
            }
        }
    } catch {
        $lines.Add("##### $repo #$n ERR " + $_.Exception.Message)
    }
    Start-Sleep -Milliseconds 600
}
[IO.File]::WriteAllLines($Out, $lines, (New-Object Text.UTF8Encoding($false)))
Write-Output "done $($lines.Count)"
