param([string]$Packs, [string]$Out)
$ErrorActionPreference = 'Continue'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$textExt = '\.(glsl|vsh|fsh|csh|gsh|tcs|tes|inc|h|properties|lang|txt|json|md)$'
function Count($t, $re) { return [regex]::Matches($t, $re, 'IgnoreCase').Count }
$rows = @()
$langOut = New-Object System.Text.StringBuilder
foreach ($d in (Get-ChildItem $Packs -Directory | Sort-Object Name)) {
    $zip = Join-Path $d.FullName 'pack.zip'
    if (-not (Test-Path $zip)) { continue }
    $slug = $d.Name
    $names = New-Object System.Collections.Generic.List[string]
    $texts = @{}
    $total = 0
    try {
        $a = [System.IO.Compression.ZipFile]::OpenRead($zip)
    } catch {
        $rows += [pscustomobject]@{ slug = $slug; error = $_.Exception.Message }
        continue
    }
    try {
        foreach ($e in $a.Entries) {
            if ($e.Length -eq 0) { continue }
            $names.Add($e.FullName)
            if ($e.FullName -match $textExt -and $e.Length -le 2MB) {
                $sr = New-Object System.IO.StreamReader($e.Open())
                $texts[$e.FullName] = $sr.ReadToEnd()
                $sr.Dispose()
                $total += $e.Length
            }
        }
    } finally { $a.Dispose() }
    $all = ($texts.Values -join "`n")
    $glsl = $texts.GetEnumerator() | Where-Object { $_.Key -match '\.(glsl|vsh|fsh|csh|gsh|inc|h)$' }
    $glslText = ($glsl | ForEach-Object { $_.Value }) -join "`n"
    $waterFiles = @($glsl | Where-Object { $_.Key -match 'water' })
    $waterText = ($waterFiles | ForEach-Object { $_.Value }) -join "`n"
    $shadowFiles = @($names | Where-Object { $_ -match '(^|/)shadow\.(fsh|vsh|glsl)$' })
    $propText = ($texts.GetEnumerator() | Where-Object { $_.Key -match 'shaders\.properties$' } | ForEach-Object { $_.Value }) -join "`n"
    $features = ''
    $m = [regex]::Matches($propText, '(?m)^\s*iris\.features\.(required|optional)\s*=\s*(.*)$')
    if ($m.Count -gt 0) { $features = ($m | ForEach-Object { $_.Groups[1].Value + ':' + $_.Groups[2].Value.Trim() }) -join ' | ' }
    $langText = ($texts.GetEnumerator() | Where-Object { $_.Key -match 'en_US\.lang$' } | ForEach-Object { $_.Value }) -join "`n"
    $featLines = @()
    foreach ($ln in ($langText -split "`n")) {
        if ($ln -match '^(option|screen|value)\.' -and $ln -notmatch '\.comment=' -and $ln -match '^(option|screen)\.[^=]*=(.*)$') {
            if ($ln -match 'water|wave|refract|reflect|shadow|caustic|ssr|raytrac|ray trac') { $featLines += $ln.Trim() }
        }
    }
    if ($featLines.Count -gt 0) {
        [void]$langOut.AppendLine("## $slug")
        foreach ($l in $featLines) { [void]$langOut.AppendLine($l) }
        [void]$langOut.AppendLine('')
    }
    $dh = @($names | Where-Object { $_ -match '(^|/)dh_[a-z_]+\.(fsh|vsh|glsl)$' }).Count
    $voxy = @($names | Where-Object { $_ -match 'voxy' }).Count
    $dimDirs = @($names | ForEach-Object { if ($_ -match '(?:^|/)shaders/(world-?\d+)/') { $Matches[1] } } | Sort-Object -Unique)
    $rows += [pscustomobject]@{
        slug = $slug
        files = $names.Count
        has_shaders_dir = [int](@($names | Where-Object { $_ -match '(^|/)shaders/' }).Count -gt 0)
        shadow_programs = $shadowFiles.Count
        shadowtex_refs = (Count $glslText 'shadowtex[01]|shadowcolor[01]|shadowtex')
        shadow_samples = (Count $glslText '\b(shadowtex\w*|shadowcolor\w*|shadow2D\w*|sampler2DShadow)')
        water_prog = @($names | Where-Object { $_ -match 'gbuffers_water\.(fsh|vsh|glsl)$' }).Count
        water_lib = @($names | Where-Object { $_ -match '(^|/)(water|waves?)/[^/]+\.(glsl|inc|fsh|vsh)$|/(water|wave)[A-Za-z]*\.(glsl|inc)$' }).Count
        shadow_res = ([regex]::Match($all, 'shadowMapResolution\s*=\s*(\d+)')).Groups[1].Value
        water_files = $waterFiles.Count
        water_wave = (Count $waterText 'wave|WAVING_WATER|waterwave')
        water_refract = (Count $all 'refract')
        water_caustic = (Count $all 'caustic')
        water_foam = (Count $waterText 'foam')
        reflect_refs = (Count $glslText 'reflection')
        ssr_refs = (Count $glslText '\bSSR\b|screenSpaceReflection|raytrace|rayTrace|ray_trace|raymarch')
        reflect_opts = ($featLines | Where-Object { $_ -match 'reflect|ssr' }).Count
        water_opts = ($featLines | Where-Object { $_ -match 'water|wave|refract|caustic' }).Count
        shadow_opts = ($featLines | Where-Object { $_ -match 'shadow' }).Count
        dh_programs = $dh
        voxy_files = $voxy
        compute_shaders = @($names | Where-Object { $_ -match '\.csh$' }).Count
        colorwheel = [int](@($names | Where-Object { $_ -match 'colorwheel|clrwl' }).Count -gt 0)
        dims = ($dimDirs -join ',')
        iris_features = $features
        text_kb = [int]($total / 1024)
    }
}
$rows | Export-Csv -Path (Join-Path $Out 'features.csv') -NoTypeInformation -Encoding utf8
Set-Content -Path (Join-Path $Out 'lang_options.txt') -Value $langOut.ToString() -Encoding utf8
Write-Output "scanned $($rows.Count)"
