#!/usr/bin/env bash

# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
# Change extension names to the extensions you need
npm install coc-tsserver coc-json coc-css coc-html coc-yaml --global-style
--ignore-scripts --no-bin-links --no-package-lock --only=prod --registry="https://registry.npmjs.org"
