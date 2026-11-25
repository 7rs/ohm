param([string]$Root, [string]$Dest)
$data = Join-Path $Root 'data'; $out = Join-Path $Root 'out'
New-Item -ItemType Directory -Force $Dest | Out-Null
$scores = Import-Csv (Join-Path $out 'final_scores.csv')
$feat = Import-Csv (Join-Path $out 'features.csv')
$srch = Get-Content (Join-Path $data 'A_user_filter.json') -Raw | ConvertFrom-Json
$vers = Get-Content (Join-Path $data 'versions.json') -Raw | ConvertFrom-Json
$map = @{}; foreach ($h in $srch) { $map[$h.slug] = $h }
$fmap = @{}; foreach ($f in $feat) { $fmap[$f.slug] = $f }

$products = foreach ($s in ($scores | Sort-Object { [double]$_.score } -Descending)) {
    $h = $map[$s.slug]
    $status = 'researched'; $reason = ''
    if ($s.gate -ne '1') {
        $status = 'excluded'
        $miss = @(); if ($s.S -ne '1') { $miss += 'shadows' }; if ($s.R -ne '1') { $miss += 'reflections' }; if ($s.W -ne '1') { $miss += 'water surface' }
        $reason = 'user requirement: no ' + ($miss -join ' / ') + ' found in the shader code (measured by reading)'
    } elseif ($s.oculus_fit -eq '0') {
        $status = 'excluded'; $reason = $s.note
    }
    [pscustomobject]@{
        id = $s.slug; company = $h.author; product = $h.title; variant = ''; model_number = $s.latest_1201
        tags = (($h.categories | Where-Object { $_ -notin @('iris', 'optifine') }) -join ' ')
        catalogue_url = 'https://modrinth.com/shader/' + $s.slug; status = $status; exclusion_reason = $reason
    }
}
$products | Export-Csv (Join-Path $Dest 'products.csv') -NoTypeInformation -Encoding utf8

$m = New-Object System.Collections.Generic.List[object]
function Add-M($id, $crit, $val, $type, $src, $url) { $m.Add([pscustomobject]@{ id = $id; criterion = $crit; value = $val; type = $type; source = $src; source_url = $url }) }
foreach ($s in $scores) {
    $slug = $s.slug; $f = $fmap[$slug]; $h = $map[$slug]
    $page = 'https://modrinth.com/shader/' + $slug
    $api = 'https://api.modrinth.com/v2/project/' + $slug
    Add-M $slug 'downloads' $h.downloads 'measured' 'Modrinth API (project total)' $api
    Add-M $slug 'latest_1.20.1_iris_version' ($s.latest_1201 + ' (' + $s.latest_date + ')') 'measured' 'Modrinth API (version list, game_versions=1.20.1, loaders=iris)' ($api + '/version')
    Add-M $slug 'shadow_map_sampling' ("programs=" + $f.shadow_programs + '; samples=' + $f.shadow_samples) 'measured' 'zip scan (shadow.* programs, shadowtex/shadowcolor/shadow2D tokens)' $page
    Add-M $slug 'ssr_or_raymarch_tokens' $f.ssr_refs 'measured' 'zip scan (SSR, raytrace, raymarch tokens in GLSL)' $page
    Add-M $slug 'reflection_tokens_and_options' ("glsl=" + $f.reflect_refs + '; lang_options=' + $f.reflect_opts) 'measured' 'zip scan (reflection token count; en_US.lang option labels)' $page
    Add-M $slug 'water_program_and_wave' ("gbuffers_water=" + $f.water_prog + '; wave=' + $f.water_wave + '; lang_options=' + $f.water_opts) 'measured' 'zip scan (gbuffers_water program, wave tokens)' $page
    Add-M $slug 'refraction_tokens' $f.water_refract 'measured' 'zip scan' $page
    Add-M $slug 'caustic_tokens' $f.water_caustic 'measured' 'zip scan' $page
    Add-M $slug 'distant_horizons_programs' $f.dh_programs 'measured' 'zip scan (dh_*.fsh/vsh/glsl files)' $page
    Add-M $slug 'colorwheel_support' $s.colorwheel 'measured' 'zip scan (colorwheel / clrwl files); patcher and fallback lists from the Colorwheel page' 'https://modrinth.com/mod/colorwheel'
    Add-M $slug 'iris_features_declared' $(if ($f.iris_features) { $f.iris_features } else { 'none' }) 'measured' 'shaders.properties' $page
    Add-M $slug 'performance_tag' $(if ($s.perf_tags) { $s.perf_tags } else { 'none' }) 'claimed' 'Modrinth tags set by the author' $page
    Add-M $slug 'colored_lighting_tag' $s.colored_lighting_tag 'claimed' 'Modrinth tag set by the author' $page
}
$m | Export-Csv (Join-Path $Dest 'measurements.csv') -NoTypeInformation -Encoding utf8
Copy-Item (Join-Path $out 'features.csv') (Join-Path $Dest 'features.csv') -Force
Copy-Item (Join-Path $out 'final_scores.csv') (Join-Path $Dest 'final_scores.csv') -Force
Write-Output "products: $($products.Count); measurements: $($m.Count)"
