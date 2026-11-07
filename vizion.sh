#!/usr/bin/env bash
#
# Vizion theme CLI for Paymenter
# Usage: ./vizion.sh {install|update|uninstall|help}
#
set -euo pipefail

THEME_NAME="vizion"
PAYMENTER_PATH="${PAYMENTER_PATH:-/var/www/paymenter}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$REPO_DIR/themes/$THEME_NAME"
DEST_DIR="$PAYMENTER_PATH/themes/$THEME_NAME"

print_banner() {
  echo "========================"
  echo "      V I Z I O N"
  echo "========================"
  echo
}

check_paymenter() {
  if [ ! -f "$PAYMENTER_PATH/artisan" ]; then
    echo "Error: Paymenter nahi mila at $PAYMENTER_PATH. PAYMENTER_PATH set karke dobara try karein." >&2
    exit 1
  fi
  if ! command -v npm >/dev/null 2>&1; then
    echo "Error: npm installed nahi hai. Node.js 20 ya usse upar install karein." >&2
    exit 1
  fi
}

check_source() {
  if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Theme source nahi mila at $SRC_DIR" >&2
    exit 1
  fi
}

build_assets() {
  echo "-> Assets build ho rahe hain..."
  (cd "$PAYMENTER_PATH" && npm install && npm run build "$THEME_NAME")
}

install_theme() {
  print_banner
  check_paymenter
  check_source
  if [ -d "$DEST_DIR" ]; then
    echo "Vizion pehle se installed hai. Update ke liye './vizion.sh update' chalayein."
    exit 1
  fi
  echo "-> Theme copy ho rahi hai: $DEST_DIR"
  mkdir -p "$PAYMENTER_PATH/themes"
  cp -r "$SRC_DIR" "$DEST_DIR"
  build_assets
  echo
  echo "Install complete. Admin panel > Settings > Theme mein 'Vizion' select karke enable karein."
}

update_theme() {
  print_banner
  check_paymenter
  check_source
  if [ ! -d "$DEST_DIR" ]; then
    echo "Vizion installed nahi hai. Pehle './vizion.sh install' chalayein." >&2
    exit 1
  fi
  if [ -d "$REPO_DIR/.git" ]; then
    echo "-> Latest changes pull ho rahe hain..."
    git -C "$REPO_DIR" pull --ff-only
  fi
  echo "-> Purani theme files hata kar nayi files copy ho rahi hain..."
  rm -rf "$DEST_DIR"
  cp -r "$SRC_DIR" "$DEST_DIR"
  build_assets
  echo
  echo "Update complete."
}

uninstall_theme() {
  print_banner
  check_paymenter
  if [ ! -d "$DEST_DIR" ]; then
    echo "Vizion installed nahi hai." >&2
    exit 1
  fi
  echo "Ye Vizion theme ko Paymenter se remove kar dega."
  echo "Pehle admin panel mein koi dusri theme (jaise default) active kar lein."
  read -r -p "Continue karein? (y/N): " answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *) echo "Cancel ho gaya."; exit 0 ;;
  esac
  rm -rf "$DEST_DIR"
  (cd "$PAYMENTER_PATH" && npm run build)
  echo
  echo "Uninstall complete."
}

usage() {
  print_banner
  echo "Usage: ./vizion.sh <command>"
  echo
  echo "Commands:"
  echo "  install     Theme ko Paymenter mein install karein aur assets build karein"
  echo "  update      Latest theme files copy karein aur assets dobara build karein"
  echo "  uninstall   Theme ko Paymenter se remove karein"
  echo "  help        Ye help message dikhayein"
  echo
  echo "Environment variable: PAYMENTER_PATH (default: /var/www/paymenter)"
}

case "${1:-help}" in
  install)        install_theme ;;
  update)         update_theme ;;
  uninstall)      uninstall_theme ;;
  help|-h|--help) usage ;;
  *)              echo "Unknown command: $1"; echo; usage; exit 1 ;;
esac
