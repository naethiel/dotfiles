#!/usr/bin/env bash

# Install vim-plug

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

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
