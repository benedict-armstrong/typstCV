# Typst CV

Typst version of my CV. Content lives in `typst/content/`, separate from the layouts that render it.

## Content

| File | What |
| --- | --- |
| `cv.yaml` | Section order for the one-file-per-entry folders |
| `profile.md` | Name, headline and contact (frontmatter); short summary (body) |
| `about.md` | Personal bio (caption of the headshot figure) |
| `research.md` | Current research position (frontmatter); explainer (body) |
| `experience/*.md`, `projects/*.md` | One entry per file: fields in frontmatter, description in the body |
| `education.yaml`, `teaching.yaml`, `skills.yaml` | Tabular data |
| `publications.yaml`, `talks.yaml` | References; `key` is the citation label |

Markdown bodies are rendered with [cmarker](https://typst.app/universe/package/cmarker); short text fields in YAML accept inline Markdown too.
Dates use `from`/`to`: `to: present` means ongoing, no `to` means a single point in time.
To add an experience or project entry, create the file and add its name to `cv.yaml`.

`typst/lib/content.typ` loads everything into one dictionary (`load-cv()`) that every layout uses.

## Layouts

| Variant | Source | PDF |
| --- | --- | --- |
| Classic (two-column) | `typst/cv.typ` | [cv.pdf](https://benedict-armstrong.github.io/typstCV/cv.pdf) |
| Modern (single-column) | `typst/cv-modern.typ` | [cv-modern.pdf](https://benedict-armstrong.github.io/typstCV/cv-modern.pdf) |
| Paper (NeurIPS-style) | `typst/cv-paper.typ` | [cv-paper.pdf](https://benedict-armstrong.github.io/typstCV/cv-paper.pdf) |
| Academic (paper typography, wrapped headshot figure) | `typst/cv-academic.typ` | [cv-academic.pdf](https://benedict-armstrong.github.io/typstCV/cv-academic.pdf) |

Build locally with `typst compile --font-path fonts typst/<variant>.typ` (Typst ≥ 0.15).

## Deploy

The CV is deployed automatically to GitHub pages using GitHub actions.
