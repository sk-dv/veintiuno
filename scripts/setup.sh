#!/usr/bin/env bash
# Instala la version de Node correcta (via nvm + .nvmrc) y TODAS las dependencias
# de la raiz, el Backend y el Frontend. Ejecutar una sola vez: npm run setup
set -e
cd "$(dirname "$0")/.."

export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  echo "ERROR: no encuentro nvm en $NVM_DIR."
  echo "Instalalo con:"
  echo '  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
  echo "y vuelve a correr: npm run setup"
  exit 1
fi
. "$NVM_DIR/nvm.sh"

echo "==> Instalando/activando Node (.nvmrc)"
nvm install
nvm use

echo "==> Dependencias raiz"
npm install

echo "==> Dependencias Backend"
npm --prefix Backend install

echo "==> Dependencias Frontend"
npm --prefix Frontend install

echo ""
echo "Setup completo. Ahora ejecuta:  npm run dev"
