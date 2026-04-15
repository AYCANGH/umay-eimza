#!/usr/bin/env node
/*
 * Generates 81 city HTML pages under /iller and a sitemap.xml at repo root.
 *   node build/generate-cities.js
 */
const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const OUT_DIR = path.join(ROOT, "iller");
const TEMPLATE_FILE = path.join(__dirname, "city-template.html");
const CITIES_FILE = path.join(__dirname, "cities.json");
const SITEMAP_FILE = path.join(ROOT, "sitemap.xml");

// ---- Domain (canonical için) ----
// Kendi domaininizi buraya yazın
const SITE = "https://e-imzasatinal.com.tr";

const template = fs.readFileSync(TEMPLATE_FILE, "utf8");
const cities = JSON.parse(fs.readFileSync(CITIES_FILE, "utf8"));

if (!fs.existsSync(OUT_DIR)) fs.mkdirSync(OUT_DIR, { recursive: true });

function render(tpl, city) {
  return tpl
    .replace(/\{\{IL_ADI\}\}/g, city.ad)
    .replace(/\{\{IL_ADI_KUCUK\}\}/g, city.ad.toLocaleLowerCase("tr-TR"))
    .replace(/\{\{IL_SLUG\}\}/g, city.slug)
    .replace(/\{\{PLAKA\}\}/g, String(city.plaka).padStart(2, "0"))
    .replace(/\{\{BOLGE\}\}/g, city.bolge)
    .replace(/\{\{ILCE_ORNEK\}\}/g, city.ilceler);
}

let count = 0;
for (const city of cities) {
  const html = render(template, city);
  const file = path.join(OUT_DIR, `${city.slug}.html`);
  fs.writeFileSync(file, html, "utf8");
  count++;
}
console.log(`✓ ${count} il sayfası üretildi → iller/`);

// ---- Sitemap.xml ----
const STATIC_PAGES = [
  "",                // index.html = "/"
  "e-imza.html",
  "kep.html",
  "hizmetler.html",
  "hakkimizda.html",
  "sss.html",
  "iletisim.html",
];

const today = new Date().toISOString().slice(0, 10);
const urls = [];

for (const p of STATIC_PAGES) {
  const loc = p === "" ? `${SITE}/` : `${SITE}/${p}`;
  const priority = p === "" ? "1.0" : "0.8";
  urls.push(
    `  <url>\n    <loc>${loc}</loc>\n    <lastmod>${today}</lastmod>\n    <changefreq>weekly</changefreq>\n    <priority>${priority}</priority>\n  </url>`
  );
}

for (const city of cities) {
  urls.push(
    `  <url>\n    <loc>${SITE}/iller/${city.slug}.html</loc>\n    <lastmod>${today}</lastmod>\n    <changefreq>monthly</changefreq>\n    <priority>0.7</priority>\n  </url>`
  );
}

const sitemap =
  `<?xml version="1.0" encoding="UTF-8"?>\n` +
  `<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n` +
  urls.join("\n") +
  `\n</urlset>\n`;

fs.writeFileSync(SITEMAP_FILE, sitemap, "utf8");
console.log(`✓ sitemap.xml üretildi (${STATIC_PAGES.length + cities.length} URL)`);
