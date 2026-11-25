param([string]$Out)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0'; 'Accept' = 'application/vnd.github+json' }
$repos = [ordered]@{
    '3dskinlayers'    = @{ repo = 'tr7zw/3d-skin-layers'; kw = @('Oculus', 'Embeddium', 'Punchy', 'ParCool', 'Entity Model Features') }
    'irons'           = @{ repo = 'iron431/Irons-Spells-n-Spellbooks'; kw = @('Oculus', 'Embeddium', 'Distant Horizons', 'TaCZ', 'Punchy') }
    'tlm'             = @{ repo = 'TartaricAcid/TouhouLittleMaid'; kw = @('Oculus', 'Embeddium', 'Entity Model Features', 'TaCZ', 'Distant Horizons') }
    'iceandfire'      = @{ repo = 'AlexModGuy/Ice_and_Fire'; kw = @('Oculus', 'Distant Horizons', 'Embeddium') }
    'witherstorm'     = @{ repo = 'nonamecrackers2/crackers-wither-storm-mod'; kw = @('Oculus', 'Embeddium', 'Distant Horizons') }
    'deeperdarker'    = @{ repo = 'KyaniteMods/DeeperAndDarker'; kw = @('Distant Horizons', 'Oculus', 'Embeddium') }
    'endrem'          = @{ repo = 'Jack-Bagel/End-Remastered'; kw = @('Distant Horizons', 'Async Locator', 'Oculus') }
    'ae2'             = @{ repo = 'AppliedEnergistics/Applied-Energistics-2'; kw = @('Oculus', 'Distant Horizons', 'FastSuite') }
    'mekanism'        = @{ repo = 'mekanism/Mekanism'; kw = @('FastSuite', 'Oculus', 'Distant Horizons') }
    'waystones'       = @{ repo = 'TwelveIterations/Waystones'; kw = @('Distant Horizons', 'Structure Layout', 'Oculus') }
    'vanillabackport' = @{ repo = 'ItsBlackGear/VanillaBackport'; kw = @('Oculus', 'Distant Horizons', 'Twilight Forest', 'Aether') }
    'botania'         = @{ repo = 'VazkiiMods/Botania'; kw = @('Oculus', 'Distant Horizons', 'Embeddium') }
    'ars'             = @{ repo = 'baileyholl/Ars-Nouveau'; kw = @('Oculus', 'Distant Horizons', 'Embeddium') }
    'createaddition'  = @{ repo = 'mrh0/createaddition'; kw = @('Create 6', 'Oculus', 'Flywheel') }
    'zombieawareness' = @{ repo = 'Corosauce/ZombieAwareness'; kw = @('TaCZ', 'Immersive Optimization', 'AI Improvements') }
    'spawnanimations' = @{ repo = 'Tschipcraft/spawnanimations'; kw = @('Fresh Animations', 'Entity Model Features', 'Forge') }
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
                $lines.Add(("  #{0} [{1}] {2} ({3})" -f $i.number, $i.state, $i.title, $i.updated_at.Substring(0, 10)))
            }
        } catch {
            $lines.Add("## $k | $kw | ERR " + $_.Exception.Message)
            Start-Sleep -Seconds 30
        }
        Start-Sleep -Seconds 7
    }
}
[IO.File]::WriteAllLines($Out, $lines, (New-Object Text.UTF8Encoding($false)))
Write-Output "done $($lines.Count) lines"
