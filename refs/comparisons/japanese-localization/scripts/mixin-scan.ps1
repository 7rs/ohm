param([string]$JarDir, [string]$OutFile)
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$targets = [ordered]@{
    'Font'              = 'Lnet/minecraft/client/gui/Font;|net\.minecraft\.client\.gui\.Font(?![A-Za-z$])'
    'GuiGraphics'       = 'Lnet/minecraft/client/gui/GuiGraphics;|net\.minecraft\.client\.gui\.GuiGraphics'
    'Language'          = 'Lnet/minecraft/locale/Language;|net\.minecraft\.locale\.Language(?![A-Za-z$])'
    'ClientLanguage'    = 'Lnet/minecraft/client/resources/language/ClientLanguage;|net\.minecraft\.client\.resources\.language\.ClientLanguage'
    'LanguageManager'   = 'Lnet/minecraft/client/resources/language/LanguageManager;|net\.minecraft\.client\.resources\.language\.LanguageManager'
    'ForgeHooksClient'  = 'Lnet/minecraftforge/client/ForgeHooksClient;|net\.minecraftforge\.client\.ForgeHooksClient'
    'LiteralContents'   = 'Lnet/minecraft/network/chat/contents/LiteralContents;|net\.minecraft\.network\.chat\.contents\.LiteralContents'
    'TranslatableContents' = 'Lnet/minecraft/network/chat/contents/TranslatableContents;|net\.minecraft\.network\.chat\.contents\.TranslatableContents'
}
$lat = [Text.Encoding]::GetEncoding(28591)
$out = New-Object System.Collections.Generic.List[object]
function Scan-Archive($zip, $label) {
    foreach ($e in $zip.Entries) {
        if ($e.FullName -notlike '*.class') { continue }
        if ($e.FullName -notmatch '(?i)mixin') { continue }
        $ms = New-Object IO.MemoryStream
        $s = $e.Open(); $s.CopyTo($ms); $s.Close()
        $t = $lat.GetString($ms.ToArray())
        if (-not $t.Contains('org/spongepowered/asm/mixin/Mixin')) { continue }
        foreach ($k in $targets.Keys) {
            if ($t -match $targets[$k]) {
                $meth = ([regex]::Matches($t, '(?<![A-Za-z0-9_])(m_\d+_|drawInBatch|drawString|drawCenteredString|width|loadFromJson|getOrDefault|getLanguage|gatherTooltipComponents|setLanguage|has|getOrDefault|create)(?![A-Za-z0-9_])') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique | Select-Object -First 6) -join ','
                $out.Add([pscustomobject]@{ mod = $label; cls = $e.FullName; target = $k; hints = $meth })
            }
        }
    }
}
foreach ($jar in Get-ChildItem $JarDir -Filter *.jar) {
    $label = ($jar.Name -split '__')[0]
    try { $z = [IO.Compression.ZipFile]::OpenRead($jar.FullName) } catch { continue }
    Scan-Archive $z $label
    foreach ($ne in ($z.Entries | Where-Object { $_.FullName -match '^META-INF/(jarjar|jars)/.*\.jar$' })) {
        try {
            $ms = New-Object IO.MemoryStream
            $s = $ne.Open(); $s.CopyTo($ms); $s.Close(); $ms.Position = 0
            $nz = New-Object IO.Compression.ZipArchive($ms)
            Scan-Archive $nz ($label + '>' + [IO.Path]::GetFileName($ne.FullName))
            $nz.Dispose()
        } catch { }
    }
    $z.Dispose()
}
$out | Export-Csv $OutFile -NoTypeInformation -Encoding UTF8
"hits: $($out.Count)"
