param([string]$JarDir, [string[]]$AltZips, [string]$OutDir)
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Web.Extensions
$js = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$js.MaxJsonLength = 2147483647
$js.RecursionLimit = 200

function Get-Bytes($e) { $ms = New-Object IO.MemoryStream; $s = $e.Open(); $s.CopyTo($ms); $s.Close(); return , $ms.ToArray() }
function Get-LangKeys($bytes) {
    $t = [Text.Encoding]::UTF8.GetString($bytes)
    if ($t.Length -gt 0 -and $t[0] -eq [char]0xFEFF) { $t = $t.Substring(1) }
    $set = New-Object 'System.Collections.Generic.HashSet[string]'
    try {
        $o = $js.DeserializeObject($t)
        if ($o -is [System.Collections.IDictionary]) { foreach ($k in $o.Keys) { [void]$set.Add([string]$k) }; return , $set }
    } catch { }
    $set.Clear()
    foreach ($m in [regex]::Matches($t, '"((?:[^"\\]|\\.)*)"\s*:\s*"')) { [void]$set.Add(($m.Groups[1].Value -replace '\\"', '"' -replace '\\\\', '\')) }
    return , $set
}

$en = @{}; $ja = @{}; $owner = @{}
foreach ($jar in Get-ChildItem $JarDir -Filter *.jar) {
    $slug = ($jar.Name -split '__')[0]
    try { $z = [IO.Compression.ZipFile]::OpenRead($jar.FullName) } catch { continue }
    foreach ($e in $z.Entries) {
        if ($e.FullName -match '^assets/([^/]+)/lang/(en_us|ja_jp)\.json$') {
            $ns = $Matches[1]; $code = $Matches[2]
            $keys = Get-LangKeys (Get-Bytes $e)
            $tbl = if ($code -eq 'en_us') { $en } else { $ja }
            if (-not $tbl.ContainsKey($ns)) { $tbl[$ns] = New-Object 'System.Collections.Generic.HashSet[string]' }
            $tbl[$ns].UnionWith($keys)
            if (-not $owner.ContainsKey($ns)) { $owner[$ns] = $slug }
        }
    }
    $z.Dispose()
}

foreach ($az in $AltZips) {
    $label = [IO.Path]::GetFileNameWithoutExtension($az)
    $alt = @{}
    $zz = [IO.Compression.ZipFile]::OpenRead($az)
    $altNs = 0
    foreach ($e in $zz.Entries) {
        if ($e.FullName -match '^assets/([^/]+)/lang/ja_jp\.json$') {
            $alt[$Matches[1]] = Get-LangKeys (Get-Bytes $e); $altNs++
        }
    }
    $zz.Dispose()
    $rows = foreach ($ns in ($en.Keys | Sort-Object)) {
        $E = $en[$ns]
        $O = if ($ja.ContainsKey($ns)) { $ja[$ns] } else { New-Object 'System.Collections.Generic.HashSet[string]' }
        $A = if ($alt.ContainsKey($ns)) { $alt[$ns] } else { $null }
        $offHit = 0; $altHit = 0; $fill = 0; $final = 0
        foreach ($k in $E) {
            $inO = $O.Contains($k); $inA = ($null -ne $A) -and $A.Contains($k)
            if ($inO) { $offHit++ }
            if ($inA) { $altHit++ }
            if ((-not $inO) -and $inA) { $fill++ }
            if ($inO -or $inA) { $final++ }
        }
        [pscustomobject]@{ mod = $owner[$ns]; ns = $ns; en = $E.Count; official_ja = $offHit; alt_has_ns = [bool]($null -ne $A); alt_hit = $altHit; alt_fills_missing = $fill; final_ja = $final }
    }
    $rows | Export-Csv (Join-Path $OutDir "coverage-$label.csv") -NoTypeInformation -Encoding UTF8
    $tot = ($rows | Measure-Object en -Sum).Sum; $off = ($rows | Measure-Object official_ja -Sum).Sum
    $fl = ($rows | Measure-Object alt_fills_missing -Sum).Sum; $fin = ($rows | Measure-Object final_ja -Sum).Sum
    "{0}: alt namespaces={1} ; pack en keys={2} ; official={3} ; alt fills={4} ; official+alt={5} ({6}%)" -f $label, $altNs, $tot, $off, $fl, $fin, [math]::Round(100 * $fin / $tot, 1)
}
