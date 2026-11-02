# Aritra Biswas website rebuild specification

- **Audit date:** 2026-10-24
- **Source reviewed:** `master` at `3e62eda`
- **Working branch:** `docs/site-rebuild-spec`
**Purpose:** describe the current site and define the content, behavior, and deployment work for a plain HTML, CSS, and JavaScript recreation.

## 1. Goal and boundaries

Recreate Aritra Biswas's personal website as a lightweight static site using semantic HTML, CSS, and vanilla JavaScript. The site combines a professional profile and portfolio with a technical blog.

Keep the current Netlify hosting account/site and the current custom domain and GoDaddy registrar/DNS arrangement. The repository does not contain the production domain or GoDaddy DNS records, so those values must be read from the existing Netlify and GoDaddy accounts when the static version is prepared. A static publish directory and build setting will need to replace the Hugo build step; this does not require changing the host, domain, or DNS records.

This document records the current site behavior, a preliminary visual concept set in `design/`, and the remaining decisions for a plain HTML, CSS, and JavaScript recreation. It is a specification and checklist, not the implementation; the visual concepts and proposed content structure still need review.

## 2. Product and implementation requirements

### Required constraints

- Build with HTML, CSS, and JavaScript; do not introduce a frontend framework or server-side application for the site itself.
- Keep the current Netlify site and GoDaddy domain/DNS arrangement.
- Preserve established public URLs, content, and uploaded files wherever possible. Add redirects for any URL that cannot be preserved.
- Treat source under `content/`, `config/`, `assets/`, `layouts/`, and `static/` as the record of intended content. Do not copy `public/` wholesale: it is generated output and currently contains pages that are not present in the source content.
- Keep all existing assets intact during migration. Mark sample/demo content for review; do not remove it until it is confirmed as disposable.
- Make pages responsive and usable by keyboard, with semantic landmarks, visible focus, form labels, meaningful image alternatives, and support for reduced motion.

### Initial design direction for discussion

- Keep technical articles in the existing Writing/blog archive.
- Give general travel stories and conference-attendance reflections a **Field Notes** area, with **Travel** and **Conference reflections** as entry points. These are proposed new groupings, not existing content or taxonomy. Keep the archive empty until real notes are written.
- Use the existing post/article format for field notes where practical, with shared search, metadata, responsive reading layout, and navigation. This avoids creating a separate publishing system for short personal writing.
- Put speaking engagements and their slide decks under **Talks**. A reflection about attending a conference belongs in Field Notes; a page about presenting at one belongs under Talks.
- The generated screens use a geometric “AB” monogram instead of an unverified generated portrait. Preserve the source avatar files; choose the real profile image separately during implementation.
- The revised visual concept is typography-first: white background, near-black text, one restrained link color, thin separators, and simple lists. Avoid decorative charts, gradients, bento cards, stock imagery, and generated portraits. The images are for design review and should be recreated as HTML/CSS/JavaScript rather than used as production page screenshots.
- The layout review took inspiration from the text-first approach in [Bear Blog](https://www.bearblog.dev/), the compact archive/navigation patterns in [PaperMod](https://adityatelange.github.io/hugo-PaperMod/), and the responsive/accessibility and publishing features in [AstroPaper](https://astro-paper.pages.dev/). These are references for principles, not templates to copy or dependencies to add.

### Design decisions intentionally deferred

- Whether to adopt the Field Notes area, its final name, and whether it should be a top-level link or a filter within Writing.
- Final visual direction and the precise order of homepage, archive, and article sections; the `design/` images are one proposal, not an approved implementation.
- Whether to retain the current light/dark/system theme selector.
- Whether to keep the `/admin/` content editor and what authoring workflow should replace Hugo/Blogdown.
- Whether to enable comments, a newsletter, or any analytics. None has a complete active configuration in this repository.
- Which sample project, course, talk, publication, privacy, and terms content should remain public.

## 3. Current site map and content

| Current route or area | What the source contains | Rebuild requirement |
|---|---|---|
| `/` | Homepage with profile/about, experience, recent posts, and contact sections | Keep the homepage and its content. The future visual order can be redesigned after blog planning. |
| `/#about`, `/#posts`, `/#contact` | Main navigation anchors | Keep the same destinations or provide equivalent accessible navigation. Experience is a homepage section but has no current top-level menu link. |
| `/post/` | Blog archive; configured for reverse chronological order and 10 items per page | Keep the archive, pagination, and post links. |
| `/post/<slug>/` | Individual posts with their existing slugs | Preserve each current path where possible; these links may already be shared externally. |
| `/category/<slug>/`, `/tag/<slug>/` | Category and tag archives | Keep taxonomy archives if these remain useful after the blog design discussion. Current categories/tags are sparse. |
| `/about/` | A separate short placeholder biography page | Review whether this should become a full About page or be consolidated with the homepage profile. |
| `/project/` and project detail pages | One recommendation-systems project and one draft external-project example | Preserve the recommendation-systems write-up; verify the draft/demo before publishing it. |
| `/publication/` and detail pages | Three Wowchemy sample publications | Verify whether these represent real publications before carrying them forward as public facts. |
| `/courses/` and `/courses/example/…` | A sample data-science course with Python, statistics, and visualization pages | Review the course/demo copy and embedded learning interactions before deciding to keep it. |
| `/talk/<slug>/` | One example talk, configured for June 2030 | Treat the event details as a sample until verified. The `/talk/` permalink comes from the `event` section. |
| `/slides/example/` | Reveal.js/Wowchemy slide demonstration | Review whether a standalone slide feature is still needed. |
| `/author/<slug>/` | Author profile/archive pages | Preserve useful author pages and their links; reconcile duplicate profile records first. |
| `/privacy/`, `/terms/` | Draft pages with placeholder bodies | Do not publish as finished policy pages without replacing and reviewing their contents. |
| `/admin/` | Wowchemy CMS configuration/editor output is present | Verify the editor's authentication and Netlify/Git integration; decide whether to retain or replace it. |
| `/404.html` | Generated not-found page | Provide a useful static 404 page. |

Hugo permalink settings also define `/author/<slug>/`, `/tag/<slug>/`, `/category/<slug>/`, `/publication-type/<slug>/`, and `/talk/<slug>/`. The static version should maintain these URLs or provide redirects. The configured home output includes HTML, RSS, JSON, a web app manifest, headers, and redirects; section outputs include HTML and RSS.

### Blog inventory

There are nine source posts. All are authored by Aritra Biswas, use dated source records, and have a `featured.png` or equivalent image in their post folder. Subtitles and summaries are blank in the current front matter, so archive excerpts are derived from the article body.

| Date | Current title | Main subject |
|---|---|---|
| 2025-03-11 | FastAPI Resiliency: Circuit Breakers, Rate Limiting, and External API Management | Resilient FastAPI services and external API dependencies |
| 2025-03-09 | On LLM reproducibility | Comparing repeatability of language model outputs |
| 2022-12-20 | Exponential Smoothing using Scikit-Learn wrapper & statsmodels | A statsmodels forecasting model exposed through a scikit-learn style wrapper |
| 2022-12-18 | LASSO using Scikit-Learn wrapper & CVXPY | LASSO optimization and model integration |
| 2021-12-18 | Avoid relative path import hell in python | Python packaging and Poetry |
| 2021-10-31 | Useful tools for docker container management | Dive, Dozzle, and Portainer |
| 2021-10-31 | SCM conventions & ways of working | Repository, branch, and commit conventions |
| 2021-10-24 | Python library version management with GitHub action + commitizen + pre-commit hook | Versioning, Commitizen, pre-commit, and GitHub Actions |
| 2021-10-16 | Local development environment with Fast API + SQLModel + SQLite + Alembic | A synchronous/asynchronous FastAPI and database setup |

The homepage displays the five newest posts and links to the full archive. Post content includes code blocks, inline links, images, and in places tables or other technical formatting. Preserve article body content and all referenced media, including GIFs, as part of migration.

The currently assigned taxonomy is limited: category `programming`; tags `python`, `ML`, `LLM`, and `GenAI`. Four older posts have no category or tags. Confirm the taxonomy during the deferred blog planning rather than inventing new categories in this specification.

### Other content records to audit

- **Project:** `RecSys for B2B platform` describes AutoML, recommendation systems, model evaluation, distributed infrastructure, monitoring, and developer workflows. A separate `External Project` entry is marked draft and uses example content.
- **Publications:** the journal article, conference paper, and preprint have generic Lorem ipsum abstracts and sample authors, venues, and/or links. Their records demonstrate metadata and citation/download actions, but should not be presented as Aritra's real work without verification.
- **Courses:** `Learn Data Science` has three child lessons (Python basics, Visualization, Statistics), embedded YouTube examples, expandable quiz answers, a table of contents, and a course CTA. Some description text is generic/demo copy.
- **Talk and slides:** `Example Talk` is associated with a fictional Wowchemy Conference at Wowchemy HQ/Stanford in 2030 and links to a demo slide deck. The slide page demonstrates Reveal.js controls, code highlighting, math, fragments, notes, themes, and custom backgrounds.
- **General About page:** `content/about.md` contains only a generic one-line placeholder biography and is separate from the homepage profile.
- **Legal pages:** Privacy Policy and Terms are drafts with `...` bodies.

## 4. Profile and personal metadata

The active homepage profile is `content/authors/admin/_index.md`, selected by the homepage About widget. Carry forward its facts and assets after confirming they remain current:

- **Name:** Aritra Biswas
- **Current role shown:** Senior Manager Analytics
- **Organization:** AB InBev (`https://www.ab-inbev.com/`)
- **Contact:** `pandalearnstocode@gmail.com`; `+91-9051237918`
- **Location in biography/experience:** originally from Calcutta/Kolkata; says he lives in Bangalore/Bengaluru; work location is Bangalore, Karnataka, India
- **Bio:** independent researcher; interests in mathematics, statistics, and computer science; enjoys reading, cooking, exploring cuisines, travel, and writing about technology and data
- **Profile bio metadata:** computational statistics, causal inference, simulation, and mathematical optimization
- **Displayed interests:** Machine Learning Engineering; Architecture; MLOps & Observability; Software Development
- **Education:** M.Sc. in Statistics, University of Delhi (2017); B.Sc. in Statistics, Presidency College (2015)
- **Resume:** `static/uploads/aritrabiswas_resume.pdf`, linked for download in a new tab
- **Avatar:** JPEG variants are in `content/authors/admin/`; preserve them and choose the current source image during visual review.

Social links in the active profile:

- Twitter/X: `https://twitter.com/pdlearnstocode`
- YouTube: `https://www.youtube.com/channel/UCd3o4IJUJSmOFr6kHv6Y3vw`
- GitHub: `https://github.com/pandalearnstocode`
- LinkedIn: `https://www.linkedin.com/in/pandalearnstocode/`
- Medium: `https://medium.com/@pandalearnstocode`
- Instagram: `https://www.instagram.com/pdlearns2code`
- Stack Overflow: `https://stackoverflow.com/users/9984132/pandalearnstocode`

### Career history shown on the homepage

The experience widget is a six-entry timeline with employer logos, role, dates, location, and a short responsibility list:

| Dates | Role | Employer | Summary |
|---|---|---|---|
| Oct 2023–present | Senior Manager Analytics | AB InBev | Generative AI, applied machine learning, software development |
| Sep 2022–Sep 2023 | Senior Machine Learning Engineer | AB InBev | Recommendation systems, distributed computing |
| Sep 2021–Aug 2022 | Senior Data Scientist | AB InBev | Budget optimization, lift measurement |
| May 2020–Aug 2021 | Data Scientist | AB InBev | Marketing mix modeling, software development |
| Jul 2018–Apr 2020 | Data Scientist | The Nielsen Company | Multi-touch attribution, software development |
| May 2017–Jun 2018 | Associate Data Scientist | The Nielsen Company | Market mix modeling, scenario planning, budget simulator |

### Profile data conflict to resolve

`content/authors/authors/_index.md` contains a second profile for the same person. It identifies him as a Senior ML Engineer, has an older bio and different interests, and omits the newer travel countries. The active homepage uses `admin`; use that record as the migration starting point and reconcile the duplicate before creating a single profile source.

## 5. Current features and behavior

| Feature | Current evidence/configuration | Migration requirement or caveat |
|---|---|---|
| Header/navigation | Logo; About me, Posts, Contact anchors; active-link styling; language selector disabled | Keep clear navigation and mobile operation. Language is English only today. |
| Responsive layout | Wowchemy theme layout, including a profile/content split on wide screens | Rebuild responsive behavior in CSS; stack content cleanly on narrow screens. |
| Appearance | Wowchemy `minimal` theme, large font setting, circular avatar, blue accent visible in generated output (`#1565c0`) | Use as a reference only; final visual choices remain open. The theme selector offers light, dark, and automatic modes. |
| Homepage sections | Profile/About, Experience, Recent Posts, Contact; configured in that order | Preserve these content functions even if the blog discussion changes their presentation. |
| Recent posts | Five newest posts, reverse chronological, compact listing view; link to `/post/` | Keep latest-first ordering and a path to the complete archive. |
| Post archive | Page size 10; compact view; section RSS configured | Keep pagination, post metadata, and feed behavior. |
| Article pages | Reading time and sharing enabled; related posts enabled; syntax highlighting enabled for R, Python, and LaTeX | Support readable long-form text, headings, code blocks, images, links, metadata, and related-post navigation. Preserve share/read-time behavior if it remains useful. |
| Search | Header search enabled; Wowchemy client search provider; home JSON output configured; Algolia credentials blank | Recreate client-side search over a static index or make a documented decision to drop it. Search should work without a backend. |
| Theme preference | Day/night enabled; generated header offers light, dark, and auto | Preserve the preference control if retained in design; ensure readable contrast in both modes. |
| Social/profile links | Icons link to the seven services listed above | Keep links, accessible names, and safe new-tab behavior. |
| Resume and files | Resume plus CSV files are under `static/uploads/` | Keep stable download URLs or redirect old paths. |
| Contact details | Email and phone are auto-linked | Use `mailto:` and `tel:` links and keep the contact details consistent with the active profile. |
| Contact form | Name, email, message fields; required; submit endpoint is `https://formspree.io/f/test`; Netlify CAPTCHA is configured off | `test` is a placeholder endpoint. Verify the intended form service/endpoint and test delivery before launch. Do not claim form submissions work until verified. |
| Comments | Commentable types are configured, but `comments.provider` is blank | No active comments provider is configured. Treat comments as unimplemented unless chosen later. |
| Related content | Related posts, projects, publications, and events are configured | Recreate only where the corresponding content is verified and relevant. |
| SEO and discovery | Person site type; English `en-us`; author/title metadata; generated Open Graph/Twitter metadata and JSON-LD search action; robots, sitemap, RSS, and web manifest output | Preserve page titles/descriptions, canonical URLs, social previews, sitemap, robots, and feeds in the static implementation. Add a 404 page and test direct route loads. |
| Analytics/privacy | Analytics, Tag Manager, verification IDs, and privacy pack are blank/disabled | No analytics or consent tooling is currently configured in source. Do not add trackers by default. |
| Content editor | Wowchemy CMS output and `public/admin/config.yml` exist; local CMS backend is disabled | Verify actual editor login and Git integration; decide whether a static authoring workflow is enough. |

## 6. Design reference and content/assets to retain

The revised concept set in `design/` uses a white background, black/gray typography, one blue link color, thin rules, and text-led sections. It removes the generated portraits, decorative charts, gradients, and stock-photo cards from the first pass. Desktop screenshots are landscape; the mobile homepage is portrait. Search and the theme setting remain small header tools. `design/concepts.html` is the local HTML/CSS source used to render the screens; use source content and verified profile assets when implementing the site. The screenshots are not production assets or an authoritative source for copy. Generated output identifies Wowchemy 5.3.0. The static rebuild does not need to reproduce Wowchemy internals.

### Concept screens and feature coverage

| Design file | Coverage shown |
|---|---|
| `design/homepage-desktop.png` | Profile, interests, all six dated experience roles, latest five posts, résumé, social links, education, direct contact links, search/theme controls, and an empty Field Notes preview |
| `design/homepage-mobile.png` | Responsive profile, menu/search/theme controls, interests/social links, dated experience preview, resume, latest post, empty Field Notes preview, and direct email/phone links |
| `design/writing-archive-desktop.png` | The nine current posts, source taxonomy where present, search, category/tag filters, RSS, current single-page pagination, and a link to Field Notes |
| `design/article-on-llm-reproducibility-desktop.png` | Article metadata, table of contents, code block/copy affordance, accurate experiment outcomes, references, share actions, and related posts |
| `design/field-notes-archive-desktop.png` | Proposed Travel and Conference reflections entry points and an honest empty state; no trip or event is invented |
| `design/project-recsys-desktop.png` | The current RecSys project summary, tags, and algorithm/programming challenge groups without invented outcomes |
| `design/concepts.html` | The no-dependency HTML/CSS source used to render these review screens |

The screens cover the main profile, writing, article, mobile, Field Notes, and current project experience. They do not establish that the sample talks, slides, publications, courses, draft project, or policy pages are real/public. Keep these in the review checklist below; do not present their demo records as confirmed personal facts. The contact form also remains unverified because its current Formspree endpoint is a placeholder.

Local overrides are small but should be reviewed during the port: `assets/scss/custom.scss` sets a wide article container, larger text, featurette icon sizing, and a dark-mode contact button treatment; `static/css/main.css` styles a narrower `.content` reading column used by Blogdown output. The custom JavaScript partial adds an SVG filter for dark-mode icons and conditionally loads GitHub Buttons in production. Source content also uses Wowchemy shortcodes for resume links, figures, course table of contents, embedded YouTube, expandable quizzes/spoilers, callouts, author mentions, CTAs, and slides. Recreate these as small native HTML/CSS/JS components where the associated content is kept.

Preserve and audit these local assets:

- Current and older author avatar images.
- AB InBev and Nielsen experience logos, social/technology SVG icons, site icon, and any images referenced by content.
- All post featured images and embedded PNG/JPEG/GIF media.
- `static/uploads/aritrabiswas_resume.pdf`, `sales.csv`, `media_spend.csv`, and `trade.csv`.
- `static/media/boards.jpg`, used by the slide example.
- Existing course, event, project, publication, and slide media until those content records are reviewed.

The source also contains optional Blogdown/R authoring (`.Rprofile`, `index.Rmd`, `R/`). The Netlify path currently builds Hugo directly. A vanilla static rebuild can use a simpler editing/publishing workflow, but its authoring process must be documented before the Hugo/Blogdown workflow is retired.

## 7. Hosting, URLs, and deployment constraints

### Verified repository configuration

- Netlify builds with `hugo --gc --minify -b $URL` and publishes `public/`.
- Netlify build environment pins Hugo `0.84.4`; the R Blogdown profile selects Hugo `0.136.5`.
- Deploy previews and branch deploys use `$DEPLOY_PRIME_URL`; deploy previews allow future-dated content.
- A Netlify Hugo cache plugin is listed.
- GoDaddy and the production custom domain are not configured in tracked source.

### Migration deployment requirement

Continue serving the site from the existing Netlify site and keep the current GoDaddy domain mapping/DNS records unchanged. When the static pages are ready, point Netlify's publish directory at their static folder and remove the Hugo build command/plugin dependency for that site. Retain a branch/deploy preview path for review. Only promote the new output after route, content, form, SEO, and asset checks pass. Do not change nameservers, registrar, custom-domain binding, or DNS records as part of the rebuild.

The tracked `config.yaml` currently sets `baseurl` to `https://academic-demo.netlify.app/`, and generated `public/index.html` has localhost canonical URLs. Netlify overrides Hugo's base URL at deploy time, but these values are not a reliable record of the production domain. Read the current production URL from the existing Netlify/GoDaddy configuration when generating canonical, sitemap, and social metadata; do not infer a new domain from old links.

`public/` currently contains some generated pages and assets (including older/demo content) that do not have corresponding source under `content/`. It is generated output, not an authoritative content inventory. Build or compare fresh output from source before cutover; do not migrate those unmatched generated pages as confirmed content.

## 8. TODO checklist

### Product/content decisions

- [ ] Review the concept screens in `design/` and decide whether to adopt their visual direction and Field Notes structure before implementation.
- [ ] If Field Notes is adopted, decide its final route/navigation placement and add real Travel or Conference reflections only when ready; keep speaking engagements and slide decks under Talks.
- [ ] Confirm the blog/article/archive section details and which current features remain in the first static release.
- [ ] Decide whether the homepage remains one page or gains separate About/Experience/Projects sections in its main navigation.
- [ ] Confirm the active profile facts, portrait, employer wording, and social accounts; merge or retire the conflicting duplicate profile record.
- [ ] Review the sample publications, course, event, slides, draft project, standalone About page, and draft policy pages. Mark which are real/public, require editing, or are demonstrations to omit.
- [ ] Decide blog taxonomy and whether search, related articles, reading time, sharing, RSS, and pagination remain in the first static release.
- [ ] Confirm whether `/admin/` editing must remain; document how new posts and assets will be added if it does not.
- [ ] Select and validate a real contact form endpoint. Keep direct email and phone links regardless of form choice.
- [ ] Read the current production domain/canonical URL from Netlify and GoDaddy for metadata configuration; leave DNS and domain bindings as they are.

### Static site implementation

- [ ] Choose a dedicated static publish folder and stable content/asset layout; document the authoring steps.
- [ ] Port the homepage profile, six-entry experience history, latest-five post list, and contact section.
- [ ] Port all verified posts and preserve title/date/slug, article body, code formatting, inline links, images/GIFs, and downloads.
- [ ] Port or intentionally defer each verified project, publication, course, event, slide, and profile page.
- [ ] Preserve current public paths where possible; write redirects for routes that must change.
- [ ] Implement responsive navigation, in-page links, theme preference if retained, and client-side search if retained.
- [ ] Implement archive ordering/pagination and any chosen category/tag views.
- [ ] Add page-specific title, description, canonical URL, social preview metadata, structured author data, sitemap, robots file, RSS feed(s), web manifest, and 404 page.
- [ ] Keep local assets and public download paths; add alt text and verify every referenced file.
- [ ] Replace the placeholder contact action, test successful and invalid submissions, and confirm the success/error experience.
- [ ] Update Netlify's static publish/build settings while keeping the existing Netlify site and GoDaddy domain/DNS configuration.

### Migration review before production

- [ ] Compare the static homepage and all verified content routes against this inventory.
- [ ] Confirm every retained `/post/<slug>/` URL loads directly and every moved URL redirects correctly.
- [ ] Check profile links, employer links, resume and CSV downloads, post images, code blocks, and internal/external links.
- [ ] Check keyboard navigation, focus visibility, contrast, form labels/errors, reduced motion, and narrow-screen layouts.
- [ ] Verify search, theme preference, pagination, feeds, sitemap, robots, canonical URLs, and 404 behavior where retained.
- [ ] Review a Netlify branch/deploy preview; keep the current production deployment available as rollback until the new site is approved.
- [ ] Confirm the final Netlify publish output uses the existing domain without changing GoDaddy DNS records.

## 9. Coverage audit

This document was checked against the following source groups. The inventory above distinguishes implemented/configured features from placeholders and settings that need external verification.

| Source group | Captured in this document |
|---|---|
| `config/_default/menus.yaml`, `content/home/*.md` | Menu destinations, home section order, profile/experience/posts/contact behavior |
| `content/authors/admin/_index.md`, `content/authors/authors/_index.md` | Active profile metadata, social links, education, resume, duplicate/conflicting profile |
| `content/home/experience.md` | All six employers/roles/date ranges/responsibility summaries |
| `content/post/*/index.en.md`, `content/post/_index.md` | All nine post titles/dates/topics, taxonomy, archive, ordering, pagination, media needs |
| `content/project/`, `content/publication/`, `content/courses/`, `content/event/`, `content/slides/` | All content types, example/draft status, and notable embedded interactions |
| `content/about.md`, `content/privacy.md`, `content/terms.md`, `content/admin/` | Placeholder pages, draft legal copy, and CMS/editor integration |
| `config.yaml`, `config/_default/params.yaml`, `config/_default/languages.yaml` | Language, theme, search, sharing, reading time, comments, SEO/output, analytics, CMS settings |
| `netlify.toml`, `.Rprofile`, `index.Rmd`, `R/` | Netlify build/publish/deploy contexts and Hugo version difference; Blogdown authoring |
| `assets/`, `layouts/`, `static/` | Local styles/scripts/shortcode, icons/media, resume, CSVs, and slide media |
| `design/` | Six regenerated concept screens checked for core profile, writing, article, mobile, Field Notes, and current project coverage |
| `public/index.html`, `public/admin/config.yml`, other `public/` output | Rendered feature cross-check; output/source drift and CMS evidence noted |

**Audit result:** all source content types, profile metadata, configured user-facing behavior, downloadable/static asset groups, hosting constraints, and known uncertainties found in the reviewed branch are represented above. Production domain/DNS state, contact form delivery, CMS authentication, and the truth of sample/demo records cannot be verified from this repository and are explicitly marked for follow-up.
