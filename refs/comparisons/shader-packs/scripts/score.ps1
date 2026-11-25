param([string]$Root)
$data = Join-Path $Root 'data'; $out = Join-Path $Root 'out'
$feat = Import-Csv (Join-Path $out 'features.csv')
$srch = Get-Content (Join-Path $data 'A_user_filter.json') -Raw | ConvertFrom-Json
$vers = Get-Content (Join-Path $data 'versions.json') -Raw | ConvertFrom-Json
$map = @{}; foreach ($h in $srch) { $map[$h.slug] = $h }
$today = [datetime]'2026-11-23'

$cwPatcher = @('bsl-shaders', 'bliss-shader', 'rethinking-voxels')
$cwTested = @('kappa-shader', 'makeup-ultra-fast-shaders', 'noble', 'nostalgia-shader', 'pastel-shaders', 'sildurs-vibrant-shaders', 'super-duper-vanilla')
$oculusBlocked = @{ 'reverie_shader' = 'Author states Iris 1.8 or higher; Oculus 1.8.0 is Iris 1.7.0 parity' }

function Clamp($v) { return [Math]::Max(0, [Math]::Min(100, $v)) }
$rows = foreach ($row in $feat) {
    $slug = $row.slug
    $h = $map[$slug]
    $c = $h.categories
    $S = ([int]$row.shadow_programs -ge 1 -and [int]$row.shadow_samples -ge 3)
    $R = ((([int]$row.reflect_opts -ge 3) -or ([int]$row.ssr_refs -ge 5)) -and [int]$row.reflect_refs -ge 20)
    $W = (([int]$row.water_prog -ge 1 -or [int]$row.water_lib -ge 1) -and (([int]$row.water_wave -ge 5) -or ([int]$row.water_refract -ge 5) -or ([int]$row.water_opts -ge 3)))
    $latest = @($vers.$slug) | Sort-Object date_published -Descending | Select-Object -First 1
    $ldate = [datetime]$latest.date_published
    $months = ($today - $ldate).TotalDays / 30.4
    $depthSignals = [int]$S + [int]([int]$row.ssr_refs -ge 5) + [int]([int]$row.water_refract -ge 5) + [int]([int]$row.water_wave -ge 5) + [int]([int]$row.water_caustic -ge 5)
    $depth = $depthSignals * 20
    $dh = if ([int]$row.dh_programs -ge 2) { 100 } else { 0 }
    $cwStatus = 'none'; $cw = 20
    if ([int]$row.colorwheel -eq 1) { $cwStatus = 'official (files in zip)'; $cw = 100 }
    elseif ($cwPatcher -contains $slug) { $cwStatus = 'patcher'; $cw = 60 }
    elseif ($cwTested -contains $slug) { $cwStatus = 'fallback tested'; $cw = 40 }
    else { $cwStatus = 'fallback only'; $cw = 20 }
    $pop = Clamp (100 * ([Math]::Log10($h.downloads) - 5.0) / (7.9 - 5.0))
    $maint = Clamp (100 * (1 - $months / 36))
    $ofit = if ($oculusBlocked.ContainsKey($slug)) { 0 } else { 100 }
    $perf = (@('potato', 'low', 'medium', 'high', 'screenshot') | Where-Object { $c -contains $_ }) -join '/'
    $total = 0.25 * $depth + 0.20 * $dh + 0.15 * $cw + 0.15 * $pop + 0.15 * $maint + 0.10 * $ofit
    $totalNoCw = (0.25 * $depth + 0.20 * $dh + 0.15 * $pop + 0.15 * $maint + 0.10 * $ofit) / 0.85
    [pscustomobject]@{
        slug = $slug; title = $h.title; downloads = $h.downloads; S = [int]$S; R = [int]$R; W = [int]$W
        gate = [int]($S -and $R -and $W)
        latest_1201 = $latest.version_number; latest_date = $ldate.ToString('yyyy-MM-dd'); months_since = [Math]::Round($months, 1)
        depth = $depth; dh = $dh; dh_programs = $row.dh_programs; colorwheel = $cwStatus; cw_score = $cw
        pop = [Math]::Round($pop, 1); maint = [Math]::Round($maint, 1); oculus_fit = $ofit
        perf_tags = $perf; colored_lighting_tag = [int]($c -contains 'colored-lighting')
        score = [Math]::Round($total, 1); score_without_colorwheel = [Math]::Round($totalNoCw, 1)
        note = $(if ($oculusBlocked.ContainsKey($slug)) { $oculusBlocked[$slug] } else { '' })
    }
}
$rows | Sort-Object score -Descending | Export-Csv (Join-Path $out 'final_scores.csv') -NoTypeInformation -Encoding utf8
$g = $rows | Where-Object { $_.gate -eq 1 } | Sort-Object score -Descending
"gate passed: $($g.Count) of $($rows.Count)"
$g | Format-Table slug, downloads, depth, dh, colorwheel, pop, maint, oculus_fit, score, score_without_colorwheel, perf_tags -AutoSize | Out-String -Width 250
