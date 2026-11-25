#!/usr/bin/env bash
# Založení GitHub Pages pro svachula.cz přes GitHub CLI.
# Spouštěj ze složky Barracuda1984.github.io.
#   ./setup-gh.sh repo     – login, vytvoření repa, push, zapnutí Pages
#   ./setup-gh.sh domain   – nastavení custom domény (až po DNS u Active24)
#   ./setup-gh.sh https    – vynucení HTTPS (až po vydání certifikátu)
#   ./setup-gh.sh status   – stav Pages + kontrola DNS
set -euo pipefail

OWNER="Barracuda1984"
REPO="${OWNER}.github.io"
DOMAIN="svachula.cz"
API="repos/${OWNER}/${REPO}/pages"

case "${1:-}" in
  repo)
    gh auth status >/dev/null 2>&1 || gh auth login --hostname github.com --git-protocol https --web
    [ -d .git ] || { git init -b main; git add -A; git commit -m "Initial site for ${DOMAIN}"; }
    gh repo create "${REPO}" --public --source=. --remote=origin --push \
      --description "Web ${DOMAIN}" --homepage "https://${DOMAIN}"
    # Pages z větve main, kořen repa (statický web, bez buildu)
    gh api -X POST "${API}" -f "source[branch]=main" -f "source[path]=/" \
      || echo "Pages už možná existují – pokračuj."
    echo "Hotovo. Web poběží na https://${REPO} (za 1–2 minuty)."
    ;;
  domain)
    gh api -X PUT "${API}" -f "cname=${DOMAIN}"
    echo "Doména nastavena. GitHub teď vydává certifikát Let's Encrypt (obvykle do hodiny)."
    ;;
  https)
    gh api -X PUT "${API}" -F "https_enforced=true"
    echo "HTTPS vynuceno."
    ;;
  status)
    gh api "${API}" --jq '{status, cname, https_enforced, html_url, cert: .https_certificate.state}'
    echo "--- DNS ${DOMAIN}"
    dig +short A "${DOMAIN}"; dig +short AAAA "${DOMAIN}"
    echo "--- DNS www.${DOMAIN}"; dig +short CNAME "www.${DOMAIN}"
    echo "--- ověřovací TXT"; dig +short TXT "_github-pages-challenge-${OWNER}.${DOMAIN}"
    echo "--- MX (má zůstat beze změny)"; dig +short MX "${DOMAIN}"
    ;;
  *)
    sed -n '2,9p' "$0"; exit 1 ;;
esac
