# Ayyıldız E-İmza & KEP Bayi — Statik Web Sitesi

Türkiye'nin 81 ilinde Ayyıldız e-imza ve KEP hizmetleri sunan bayilik sitesi. Saf HTML + CSS + JS ile hazırlanmıştır, backend gerektirmez.

## Dosya Yapısı

```
.
├── index.html            # Anasayfa
├── e-imza.html           # E-İmza detay
├── kep.html              # KEP detay
├── hizmetler.html        # Zaman damgası, HSM, E-Mühür, API
├── hakkimizda.html
├── sss.html              # 17 soruluk SSS
├── iletisim.html         # WhatsApp + telefon + Google Form embed
├── iller/                # 81 il sayfası (build ile üretilir)
├── assets/
│   ├── css/style.css
│   └── js/main.js
├── build/
│   ├── cities.json              # 81 il verisi
│   ├── city-template.html       # İl sayfa şablonu
│   ├── generate-cities.js       # Node.js üretici
│   └── generate-cities.ps1      # PowerShell üretici (Windows)
├── sitemap.xml           # Üretilir (88 URL)
└── robots.txt
```

## Hızlı Başlangıç

### 1. İl sayfalarını üret

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File build\generate-cities.ps1
```

**Node.js olan sistemler:**
```bash
node build/generate-cities.js
```

Her iki komut da `iller/` altında 81 HTML dosyası ve kök dizinde `sitemap.xml` üretir.

### 2. Lokal önizleme

VS Code "Live Server" eklentisi ile `index.html` sağ tık → "Open with Live Server" en kolay yöntem. Alternatif:

```bash
# Node varsa
npx http-server -p 8000

# Python varsa
python -m http.server 8000
```

Sonra tarayıcıda `http://localhost:8000` açın.

### 3. Deploy

**Netlify (önerilen, en kolay):**
- [app.netlify.com](https://app.netlify.com) → "Add new site" → "Deploy manually"
- Tüm klasörü sürükle-bırak
- Ücretsiz SSL ve CDN otomatik aktif

**Vercel:**
- `vercel --prod` CLI ile veya Git repo bağlayarak

**GitHub Pages:**
- Repo Settings → Pages → Source: "main" branch
- Custom domain için kök dizine `CNAME` dosyası ekleyin (içeriği: `e-imzasatinal.com.tr`)

**Klasik paylaşımlı hosting (cPanel):**
- FTP ile tüm dosyaları `public_html` içine yükleyin

## Kendi Bilgilerinizi Yerleştirme

Site şu an placeholder değerlerle çalışıyor. Gerçek firma bilgilerinizi yerleştirmek için **find & replace** yapın:

| Placeholder | Gerçek değer |
|---|---|
| `Yetkili Bayi` | Firma adınız (ör. "XYZ Bilişim") |
| `e-imzasatinal.com.tr` | Domain adresiniz |
| `0850 000 00 00` | Gösterilen telefon numarası |
| `+908500000000` | `tel:` link numarası (uluslararası format) |
| `905550000000` | WhatsApp numarası (`wa.me` için, `+` ve boşluk olmadan) |
| `+90 555 000 00 00` | İletişim sayfasında gösterilen WhatsApp numarası |
| `info@e-imzasatinal.com.tr` | E-posta adresiniz |
| `İstanbul, Türkiye` | Merkez adresiniz |
| `GOOGLE_FORM_ID` | `iletisim.html` içindeki Google Form embed ID'si |

### VS Code toplu değiştirme

VS Code'da `Ctrl+Shift+H` ile proje genelinde find & replace yapabilirsiniz. Her değer için tek seferde tüm dosyalarda değişir.

### Google Form Embed

1. [Google Forms](https://docs.google.com/forms) ile başvuru formunuzu oluşturun
2. Sağ üstte "Gönder" → iframe ikonuna tıklayın
3. Size verilen `src` URL'sindeki `e/XXXXX/viewform` kısmından `XXXXX` olan ID'yi kopyalayın
4. `iletisim.html` içinde `GOOGLE_FORM_ID` yerine yapıştırın

### Build Script Domain

`build/generate-cities.ps1` (ve `generate-cities.js`) içindeki `$site` / `SITE` değişkenini kendi domaininiz ile güncelleyip tekrar çalıştırın. Bu, canonical URL'leri ve `sitemap.xml`'i günceller.

## SEO Kurulum

1. Deploy'dan sonra [Google Search Console](https://search.google.com/search-console) hesabı açın
2. Domain'inizi ekleyin, doğrulama adımını tamamlayın
3. "Sitemap'ler" kısmına `https://sizindomain.com/sitemap.xml` URL'ini ekleyin
4. Birkaç gün içinde Google tüm sayfaları indekslemeye başlar

### İpuçları

- **İl sayfaları için lokal SEO:** Her il sayfasında `{{IL_ADI}}` çok geçtiği için "İstanbul e-imza", "Ankara e-imza" gibi aramalarda görünürlük yüksektir.
- **Dahili link:** Anasayfa tüm illere link veriyor; il sayfaları da ana hizmet sayfalarına link veriyor. Bu "link juice" dağılımı SEO için önemli.
- **Sayfa başlıkları ve meta açıklamalar** her sayfada özgün ve anahtar kelime içerir.

## Geliştirme Notları

### Yeni il sayfası güncellemesi
1. `build/cities.json` veya `build/city-template.html` dosyasını düzenleyin
2. PowerShell veya Node.js generator'ı tekrar çalıştırın
3. Tüm 81 il sayfası otomatik yenilenir

### Yeni sayfa ekleme (ör. blog yazısı)
1. `index.html`'i kopyalayın, içeriği değiştirin
2. `build/generate-cities.js` içindeki `STATIC_PAGES` dizisine ekleyin
3. Generator'ı tekrar çalıştırıp sitemap'i güncelleyin
4. Navigasyona link ekleyin (tüm HTML dosyalarında header → nav)

### Daha sonra eklenebilecek SEO güçlendiricileri
- JSON-LD LocalBusiness schema (il sayfaları için çok etkili)
- Open Graph + Twitter Card meta tag'leri
- Google Analytics 4 / Tag Manager
- Web manifest + PWA özellikleri

## Lisans & Marka

- Ayyıldız® tescilli bir markadır. Bu site **yetkili satıcı** konumunu temsil eder, marka sahibi değildir.
- Tüm görsel içerik (renk paleti, tipografi) özgün tasarımdır.
