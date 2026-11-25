param([string]$JarDir, [string]$JtransJar, [string]$OutDir)
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Web.Extensions
$js = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$js.MaxJsonLength = 2147483647
$js.RecursionLimit = 200

function Read-Entry($e) {
    $sr = New-Object IO.StreamReader($e.Open(), [Text.Encoding]::UTF8)
    try { return $sr.ReadToEnd() } finally { $sr.Close() }
}
function Count-Keys($e, $ext) {
    $t = Read-Entry $e
    if ($ext -eq 'lang') {
        $n = 0
        foreach ($ln in ($t -split "`n")) { if ($ln -match '^[^#=\s][^=]*=') { $n++ } }
        return $n
    }
    try {
        $o = $js.DeserializeObject($t)
        if ($o -is [System.Collections.IDictionary]) { return $o.Count }
        return -1
    } catch {
        $m = [regex]::Matches($t, '"[^"\\]+"\s*:\s*"')
        return -2 - $m.Count
    }
}

$rows = New-Object System.Collections.Generic.List[object]
foreach ($jar in Get-ChildItem $JarDir -Filter *.jar) {
    $slug = ($jar.Name -split '__')[0]
    $z = $null
    try { $z = [IO.Compression.ZipFile]::OpenRead($jar.FullName) } catch { $rows.Add([pscustomobject]@{slug=$slug;jar=$jar.Name;ns='<<open failed>>';en=0;ja=0;jaext='';langfiles=''}); continue }
    $ns = @{}
    foreach ($e in $z.Entries) {
        if ($e.FullName -match '^assets/([^/]+)/lang/([^/]+)\.(json|lang)$') {
            $n = $Matches[1]; $code = $Matches[2].ToLower(); $ext = $Matches[3]
            if (-not $ns.ContainsKey($n)) { $ns[$n] = @{ en = 0; ja = 0; jaext = ''; codes = New-Object System.Collections.Generic.List[string] } }
            $ns[$n].codes.Add($code)
            if ($code -eq 'en_us') { $ns[$n].en = Count-Keys $e $ext }
            elseif ($code -eq 'ja_jp') { $ns[$n].ja = Count-Keys $e $ext; $ns[$n].jaext = $ext }
        }
    }
    $nested = @($z.Entries | Where-Object { $_.FullName -match '^META-INF/(jarjar|jars)/.*\.jar$' } | ForEach-Object { $_.FullName })
    if ($ns.Count -eq 0) {
        $rows.Add([pscustomobject]@{slug=$slug;jar=$jar.Name;ns='<<no lang>>';en=0;ja=0;jaext='';langfiles="nestedjars=$($nested.Count)"})
    }
    foreach ($k in $ns.Keys) {
        $rows.Add([pscustomobject]@{slug=$slug;jar=$jar.Name;ns=$k;en=$ns[$k].en;ja=$ns[$k].ja;jaext=$ns[$k].jaext;langfiles=($ns[$k].codes -join ';') + $(if($nested.Count){" nested=$($nested.Count)"}else{''})})
    }
    $z.Dispose()
}
$rows | Export-Csv (Join-Path $OutDir 'ohm-lang-scan.csv') -NoTypeInformation -Encoding UTF8

$jt = New-Object System.Collections.Generic.List[object]
$z = [IO.Compression.ZipFile]::OpenRead($JtransJar)
foreach ($e in $z.Entries) {
    if ($e.FullName -match '^(resourcepacks/[^/]+/)?assets/([^/]+)/lang/ja_jp\.(json|lang)$') {
        $pk = $Matches[1]; if (-not $pk) { $pk = '<root>' }
        $jt.Add([pscustomobject]@{pack=$pk.TrimEnd('/');ns=$Matches[2];ext=$Matches[3];ja=(Count-Keys $e $Matches[3])})
    }
}
$z.Dispose()
$jt | Export-Csv (Join-Path $OutDir 'jtrans-lang-scan.csv') -NoTypeInformation -Encoding UTF8
"ohm rows: $($rows.Count) ; jtrans rows: $($jt.Count)"
