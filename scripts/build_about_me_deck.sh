#!/usr/bin/env sh
set -eu

npx --yes @marp-team/marp-cli@4.5.1 \
  slides/about-me.marp.md \
  --theme-set slides/about-me.theme.css \
  --output static/about-me/index.html
