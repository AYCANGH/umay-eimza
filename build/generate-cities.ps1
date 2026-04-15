# Generates 81 city HTML pages under /iller and a sitemap.xml at repo root.
# Usage:  powershell -ExecutionPolicy Bypass -File build\generate-cities.ps1
# Kendi domaininizi asagida $site degiskeninde ayarlayin.

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root      = Split-Path -Parent $scriptDir
$outDir    = Join-Path $root "iller"
$tplFile   = Join-Path $scriptDir "city-template.html"
$jsonFile  = Join-Path $scriptDir "cities.json"
$sitemap   = Join-Path $root "sitemap.xml"

$site = "https://e-imzasatinal.com.tr"

if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$template = Get-Content -Raw -Path $tplFile -Encoding UTF8
$cities   = Get-Content -Raw -Path $jsonFile -Encoding UTF8 | ConvertFrom-Json

$count = 0
foreach ($c in $cities) {
    $plaka = "{0:D2}" -f [int]$c.plaka
    $ilKucuk = $c.ad.ToLower()
    $html = $template `
        -replace '\{\{IL_ADI\}\}',       $c.ad `
        -replace '\{\{IL_ADI_KUCUK\}\}', $ilKucuk `
        -replace '\{\{IL_SLUG\}\}',      $c.slug `
        -replace '\{\{PLAKA\}\}',        $plaka `
        -replace '\{\{BOLGE\}\}',        $c.bolge `
        -replace '\{\{ILCE_ORNEK\}\}',   $c.ilceler
    $outFile = Join-Path $outDir ("{0}.html" -f $c.slug)
    [System.IO.File]::WriteAllText($outFile, $html, (New-Object System.Text.UTF8Encoding($false)))
    $count++
}
Write-Host "OK - $count city pages generated -> iller/"

# --- sitemap.xml ---
$today = (Get-Date).ToString("yyyy-MM-dd")
$staticPages = @("", "e-imza.html", "kep.html", "hizmetler.html", "hakkimizda.html", "sss.html", "iletisim.html")

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
[void]$sb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
$closeTag = [char]0x3C + "/urlset" + [char]0x3E

foreach ($p in $staticPages) {
    $loc = if ($p -eq "") { "$site/" } else { "$site/$p" }
    $priority = if ($p -eq "") { "1.0" } else { "0.8" }
    [void]$sb.AppendLine("  <url>")
    [void]$sb.AppendLine("    <loc>$loc</loc>")
    [void]$sb.AppendLine("    <lastmod>$today</lastmod>")
    [void]$sb.AppendLine("    <changefreq>weekly</changefreq>")
    [void]$sb.AppendLine("    <priority>$priority</priority>")
    [void]$sb.AppendLine("  </url>")
}
foreach ($c in $cities) {
    [void]$sb.AppendLine("  <url>")
    [void]$sb.AppendLine("    <loc>$site/iller/$($c.slug).html</loc>")
    [void]$sb.AppendLine("    <lastmod>$today</lastmod>")
    [void]$sb.AppendLine("    <changefreq>monthly</changefreq>")
    [void]$sb.AppendLine("    <priority>0.7</priority>")
    [void]$sb.AppendLine("  </url>")
}
[void]$sb.AppendLine($closeTag)

[System.IO.File]::WriteAllText($sitemap, $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Host ("OK - sitemap.xml generated ({0} URLs)" -f ($staticPages.Count + $cities.Count))
