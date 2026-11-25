# svachula.cz

Osobní/firemní web na GitHub Pages. Statické `index.html`, bez buildu (`.nojekyll`).

## Postup nasazení

Skript `setup-gh.sh` je jen lokální (není v repu, ignorován přes `.git/info/exclude`).

1. **Repo + Pages** – `./setup-gh.sh repo`
   (přihlásí `gh`, založí veřejné repo `Barracuda1984.github.io`, pushne a zapne Pages z `main` /).
2. **Ověření domény** (jen přes web, API to neumí):
   GitHub → Settings (profil) → Pages → *Add a domain* → `svachula.cz`.
   Vygenerovaný TXT záznam `_github-pages-challenge-Barracuda1984` vlož do DNS u Active24 a dej *Verify*.
3. **DNS u Active24** – u kořene domény smaž stávající A/AAAA (parkovací stránka), MX nech být:
   - A: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`
   - AAAA: `2606:50c0:8000::153`, `2606:50c0:8001::153`, `2606:50c0:8002::153`, `2606:50c0:8003::153`
   - `www` CNAME → `barracuda1984.github.io.`
4. **Doména v repu** – `./setup-gh.sh domain` (soubor `CNAME` už je v repu).
5. **Kontrola** – `./setup-gh.sh status`; jakmile je certifikát `approved`, spusť `./setup-gh.sh https`.

## Před zveřejněním doplnit v `index.html`
- `EMAIL@svachula.cz`, telefon, LinkedIn URL
- po 1. 12. 2026: IČO a sídlo (patička)
