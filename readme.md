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

## Build

`typst/cv.typ` renders both a PDF and an HTML page from the same source (Typst ≥ 0.15):

```sh
typst compile --font-path fonts typst/cv.typ                                     # → typst/cv.pdf
typst compile --font-path fonts --features html --format html typst/cv.typ cv.html  # → cv.html
```

HTML export is still experimental in Typst. Layout-only parts of `cv.typ` branch on `target()`, and the page is styled by `typst/web.css`, which is inlined at compile time.

## Deploy

The CV is deployed automatically to GitHub Pages using GitHub Actions: the HTML version at [benedict-armstrong.github.io/typstCV](https://benedict-armstrong.github.io/typstCV/), the PDF at [cv.pdf](https://benedict-armstrong.github.io/typstCV/cv.pdf).
