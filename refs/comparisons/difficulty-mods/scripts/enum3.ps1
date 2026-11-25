param([string]$Out, [string]$Terms, [string]$Name = 'search_raw3.csv')
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ua = @{ 'User-Agent' = 'packwiz-pack-review/1.0' }
$base = 'https://api.modrinth.com/v2'
$facets = [uri]::EscapeDataString('[["project_type:mod"],["versions:1.20.1"],["categories:forge"]]')
$q = Get-Content $Terms -Raw | ConvertFrom-Json
New-Item -ItemType Directory -Force $Out | Out-Null
$rows = New-Object System.Collections.Generic.List[object]
foreach ($axis in $q.PSObject.Properties.Name) {
    foreach ($term in $q.$axis) {
        $enc = [uri]::EscapeDataString($term)
        $uri = "$base/search?query=$enc&facets=$facets&limit=40"
        try {
            $r = Invoke-RestMethod -Uri $uri -Headers $ua
        } catch {
            Write-Output ("FAIL " + $term + " " + $_.Exception.Message)
            continue
        }
        $rank = 0
        foreach ($h in $r.hits) {
            $rank++
            $rows.Add([pscustomobject]@{
                axis = $axis; query = $term; rank = $rank; slug = $h.slug; title = $h.title
                downloads = $h.downloads; follows = $h.follows; modified = $h.date_modified.Substring(0, 10)
                client = $h.client_side; server = $h.server_side
                categories = ($h.display_categories -join ';')
                description = ($h.description -replace '[\r\n,]', ' ')
            })
        }
        Start-Sleep -Milliseconds 300
    }
}
$rows | Export-Csv (Join-Path $Out $Name) -NoTypeInformation -Encoding utf8
Write-Output ("rows=" + $rows.Count + " unique=" + (($rows | Select-Object -ExpandProperty slug -Unique).Count))
