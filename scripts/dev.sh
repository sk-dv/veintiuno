#!/usr/bin/env bash
# Levanta Backend (puerto 8080) y Frontend (puerto 3000) juntos, con la version
# de Node correcta. Ejecutar con: npm run dev
set -e
cd "$(dirname "$0")/.."

export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  echo "ERROR: no encuentro nvm. Corre primero: npm run setup"
  exit 1
fi
. "$NVM_DIR/nvm.sh"
nvm use >/dev/null

npx concurrently -k -n backend,frontend -c blue,green \
  "npm --prefix Backend run dev" \
  "npm --prefix Frontend start"
