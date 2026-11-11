// Loads the CV from `typst/content/` (see `content/cv.yaml`) into one dictionary.
//
// The shape matches the old `configuration.yml`, so every variant can do
// `#let configuration = load-cv()` and keep its field accesses. Prose (Markdown bodies
// and short text fields) comes back as rendered content; names, tags and dates stay strings.
#import "@preview/cmarker:0.1.10"

#let dir = "../content/"

// Inline/block Markdown → content.
#let md(s) = if s == none { none } else { cmarker.render(str(s), set-document-title: false) }

// A Markdown file with optional YAML frontmatter → (meta, body).
#let md-file(path) = {
  let (meta, body) = cmarker.render-with-metadata(
    read(dir + path),
    metadata-block: "frontmatter-yaml",
    set-document-title: false,
  )
  (if meta == none { (:) } else { meta }, body)
}

#let str-or-none(v) = if v == none { none } else { str(v) }

// New convention (no `to` = single point, `to: present` = ongoing) → old one ("_" / "").
#let norm-dates(d) = {
  let to = d.at("to", default: none)
  d.from = str(d.from)
  d.to = if to == none { "_" } else if str(to) == "present" { "" } else { str(to) }
  d
}

#let md-list(items) = if items == none { () } else { items.map(md) }

#let load-cv() = {
  let manifest = yaml(dir + "cv.yaml")

  let (profile, summary) = md-file("profile.md")
  let (research, explainer) = md-file("research.md")
  research = norm-dates(research)
  research.explainer = explainer
  research.highlights = md-list(research.at("highlights", default: ()))
  research.talks = yaml(dir + "talks.yaml")

  let jobs = manifest.experience.map(slug => {
    let (meta, body) = md-file("experience/" + slug + ".md")
    meta = norm-dates(meta)
    meta.company.link = meta.company.at("link", default: none)
    meta.description = body
    meta.highlights = md-list(meta.at("highlights", default: ()))
    meta.tags = meta.at("tags", default: ())
    meta
  })

  let projects = manifest.projects.map(slug => {
    let (meta, body) = md-file("projects/" + slug + ".md")
    meta.description = body
    meta.repo = meta.at("repo", default: none)
    meta.tags = meta.at("tags", default: ())
    meta
  })

  let teaching = yaml(dir + "teaching.yaml").map(group => {
    group.roles = group.roles.map(role => {
      role = norm-dates(role)
      role.description = md(role.at("description", default: none))
      role.highlights = md-list(role.at("highlights", default: ()))
      role
    })
    group
  })

  let publications = yaml(dir + "publications.yaml").map(p => {
    p.year = str(p.year)
    p.summary = md(p.at("summary", default: none))
    p
  })

  let skills = yaml(dir + "skills.yaml")

  (
    name: profile.name,
    headline: profile.at("headline", default: none),
    contact: profile.contact,
    summary: summary,
    about: cmarker.render(read(dir + "about.md")),
    research: research,
    publications: publications,
    projects: projects,
    jobs: jobs,
    teaching: teaching,
    education: yaml(dir + "education.yaml").map(norm-dates),
    skills: (
      languages: skills.languages,
      // Grouped dictionary (paper variants) and flat list (others).
      groups: skills.technologies,
      technologies: skills.technologies.values().flatten(),
    ),
  )
}
