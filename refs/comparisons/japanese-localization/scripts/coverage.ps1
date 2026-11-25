param([string]$JarDir, [string]$JtransJar, [string]$OutDir)
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Web.Extensions
$js = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$js.MaxJsonLength = 2147483647
$js.RecursionLimit = 200

function Get-Bytes($e) {
    $ms = New-Object IO.MemoryStream
    $s = $e.Open(); $s.CopyTo($ms); $s.Close()
    return , $ms.ToArray()
}
function Get-LangKeys($bytes) {
    $t = [Text.Encoding]::UTF8.GetString($bytes)
    if ($t.Length -gt 0 -and $t[0] -eq [char]0xFEFF) { $t = $t.Substring(1) }
    $set = New-Object 'System.Collections.Generic.HashSet[string]'
    try {
        $o = $js.DeserializeObject($t)
        if ($o -is [System.Collections.IDictionary]) {
            foreach ($k in $o.Keys) { [void]$set.Add([string]$k) }
            return , $set
        }
    } catch { }
    $set.Clear()
    foreach ($m in [regex]::Matches($t, '"((?:[^"\\]|\\.)*)"\s*:\s*"')) {
        $k = $m.Groups[1].Value -replace '\\"', '"' -replace '\\\\', '\'
        [void]$set.Add($k)
    }
    return , $set
}
function Get-DbKeys($bytes) {
    $set = New-Object 'System.Collections.Generic.HashSet[string]'
    if ($bytes.Length -lt 8) { return , $set }
    if (-not ($bytes[0] -eq 0x4a -and $bytes[1] -eq 0x54 -and $bytes[2] -eq 0x44 -and $bytes[3] -eq 0x32)) { return , $set }
    $count = ([int]$bytes[4] -shl 24) -bor ([int]$bytes[5] -shl 16) -bor ([int]$bytes[6] -shl 8) -bor [int]$bytes[7]
    $pos = 8
    for ($i = 0; $i -lt $count; $i++) {
        if ($pos + 4 -gt $bytes.Length) { break }
        $len = ([int]$bytes[$pos] -shl 24) -bor ([int]$bytes[$pos + 1] -shl 16) -bor ([int]$bytes[$pos + 2] -shl 8) -bor [int]$bytes[$pos + 3]
        $pos += 4
        if ($len -lt 0 -or $pos + $len -gt $bytes.Length) { break }
        $k = [Text.Encoding]::UTF8.GetString($bytes, $pos, $len)
        $pos += $len
        if ($k.Length -ge 2 -and $k[0] -eq '"' -and $k[$k.Length - 1] -eq '"') { $k = $k.Substring(1, $k.Length - 2) }
        $k = $k -replace '\\"', '"' -replace '\\\\', '\'
        [void]$set.Add($k)
    }
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

$jt = @{}
$zj = [IO.Compression.ZipFile]::OpenRead($JtransJar)
foreach ($e in $zj.Entries) {
    if ($e.FullName -match '^resourcepacks/jtrans_1201/assets/([^/]+)/lang/ja_jp\.json$') {
        $ns = $Matches[1]
        $b = Get-Bytes $e
        $txt = [Text.Encoding]::UTF8.GetString($b)
        if ($txt -match '__jtrans_db_v1__"\s*:\s*"([0-9a-f]{64})/([0-9a-f]{64})"') {
            $a = $Matches[1]
            $be = $zj.GetEntry("META-INF/jtrans/db/v1/$a.bin")
            if ($be) { $jt[$ns] = Get-DbKeys (Get-Bytes $be) } else { $jt[$ns] = New-Object 'System.Collections.Generic.HashSet[string]' }
        } else {
            $jt[$ns] = Get-LangKeys $b
        }
    }
}
$zj.Dispose()

$rows = foreach ($ns in ($en.Keys | Sort-Object)) {
    $E = $en[$ns]
    $O = if ($ja.ContainsKey($ns)) { $ja[$ns] } else { New-Object 'System.Collections.Generic.HashSet[string]' }
    $J = if ($jt.ContainsKey($ns)) { $jt[$ns] } else { $null }
    $offHit = 0; $jtHit = 0; $fill = 0; $final = 0
    foreach ($k in $E) {
        $inO = $O.Contains($k)
        $inJ = ($null -ne $J) -and $J.Contains($k)
        if ($inO) { $offHit++ }
        if ($inJ) { $jtHit++ }
        if ((-not $inO) -and $inJ) { $fill++ }
        if ($inO -or $inJ) { $final++ }
    }
    [pscustomobject]@{
        mod = $owner[$ns]; ns = $ns; en = $E.Count; official_ja = $offHit; official_missing = ($E.Count - $offHit)
        jtrans_has_ns = [bool]($null -ne $J); jtrans_keys = $(if ($J) { $J.Count } else { 0 }); jtrans_hit = $jtHit
        jtrans_fills_missing = $fill; final_ja = $final
    }
}
$rows | Export-Csv (Join-Path $OutDir 'coverage.csv') -NoTypeInformation -Encoding UTF8
"namespaces with en_us.json in pack: $($rows.Count)"
"jtrans_1201 namespaces: $($jt.Count)"
