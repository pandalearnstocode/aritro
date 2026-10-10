# Aritra Biswas — personal website

This repository contains the source for Aritra Biswas's personal website. It uses Hugo with Wowchemy v5 modules, with optional Blogdown/R support for authoring and rendering content.

## Project layout

- `content/` — pages and site content. Home page sections are in `content/home/`; blog posts are in `content/post/`.
- `config.yaml` and `config/_default/` — Hugo, Wowchemy, language, menu, and site settings.
- `assets/`, `layouts/`, and `static/` — local styling and template overrides, processed assets, and files copied directly to the site.
- `R/`, `index.Rmd`, and `.Rprofile` — Blogdown integration.
- `public/` and `resources/_gen/` — generated output/cache; do not edit these directly.

## Preview and build

Run `hugo server` to preview locally, or `hugo --gc --minify` to build the site. Netlify builds use Hugo `0.84.4`; the Blogdown profile selects `0.136.5`.

For editing conventions and repo-specific guidance for Codex, see [AGENTS.md](AGENTS.md).

## Current TODOs

- Update transparent SVG logos.
- Update the resume.
