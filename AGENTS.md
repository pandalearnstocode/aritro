# Repository guidance

## What this repo is

This is Aritra Biswas's personal website, built with Hugo and the Wowchemy v5 modules. It also keeps Blogdown/R support for authoring posts. It is a content site, not an application repository: there is no package-managed test suite or build script.

## Where to work

- `content/`: site pages, posts, projects, publications, courses, and profile data. Home page sections live in `content/home/`.
- `config.yaml` and `config/_default/`: Hugo and Wowchemy site, language, parameter, and menu configuration.
- `assets/` and `layouts/`: local style, image/icon, JavaScript, and template overrides.
- `R/`, `index.Rmd`, and `.Rprofile`: optional Blogdown authoring/build support.
- `static/`: files copied to the site without processing.
- `themes/`: upstream starter/module code. Prefer local overrides in `layouts/` or `assets/`; edit upstream code only when the task specifically requires it.
- `public/` and `resources/_gen/`: generated Hugo output/cache. Do not edit by hand; regenerate when needed.

## Working rules

- Make the smallest change in the site's own content, config, or override layer that solves the request.
- Preserve existing Markdown front matter and the folder structure used by sibling content.
- Keep personal content and uploaded files intact. Do not replace or remove resume, data, media, or generated files unless explicitly requested.
- Treat Hugo's module imports in `config.yaml` as dependencies; do not copy module code into the site.
- There are no repository test or lint commands. For site changes, use a Hugo build when the local Hugo installation and modules are available; inspect the affected page/config when a full build cannot run.

## Build and preview

- Preview: `hugo server`
- Production-style local build: `hugo --gc --minify`
- Netlify builds with Hugo `0.84.4` in `netlify.toml`; `.Rprofile` configures Blogdown to use Hugo `0.136.5`. Keep that version difference in mind when diagnosing local-versus-deploy behavior; do not change either version unless the task calls for it.
