// Academic variant: a CV that borrows the typography of a research paper
// (Computer Modern, numbered sections, booktabs tables, figure captions, numbered references)
// without pretending to be one.
#import "@preview/meander:0.4.5"
#import "lib/content.typ": load-cv

#let cv = load-cv()
#let r = cv.research

#let accent = rgb("#1f4e79")
#let muted = luma(105)
#let phi = (1 + calc.sqrt(5)) / 2

/* ---------- Output target ---------- */

// The same source compiles to PDF (`typst compile`) and to HTML
// (`typst compile --features html --format html`). Layout-only bits branch on the target;
// on the web, `web.css` takes over spacing and typography.
#let on-web(web, paged) = context if target() == "html" { web } else { paged }
#let gap(amount) = on-web(none, v(amount))
// Both branches are evaluated eagerly, and the `html` module only exists with `--features html`.
#let el(tag, class: none, attrs: (:), body) = if "html" in dictionary(std) {
  std.html.elem(tag, attrs: if class == none { attrs } else { attrs + (class: class) }, body)
}

/* ---------- Page & type ---------- */

#set document(title: cv.name + " – Curriculum Vitae", author: cv.name)
#show: doc => on-web(
  {
    el("style", read("web.css"))
    doc
  },
  doc,
)
#show: doc => on-web(doc, {
  set page(
    paper: "a4",
    margin: (x: 25mm, top: 20mm, bottom: 22mm),
    footer: context {
      set text(size: 8pt, fill: muted)
      let n = counter(page).get().first()
      // if n == 1 [
      //   _Curriculum Vitae. Compiled #datetime.today().display("[month repr:long] [year]")._
      // ] else [
      //   _#cv.name — Curriculum Vitae_
      // ]
      h(1fr)
      counter(page).display("1 of 1", both: true)
    },
  )
  doc
})
#set text(font: "New Computer Modern", size: 10pt)
#set par(justify: true, leading: 0.58em, spacing: 0.8em)
#set list(indent: 0.4em, body-indent: 0.5em, spacing: 0.5em)
#show link: set text(fill: accent)

#set heading(numbering: "1")
#show heading.where(level: 1): it => on-web(
  el(
    "h2",
    attrs: if it.has("label") { (id: str(it.label)) } else { (:) },
    {
      el("span", class: "num", counter(heading).display())
      it.body
    },
  ),
  block(sticky: true, above: 1.35em, below: 0.7em, {
    set text(size: 11.5pt, weight: "bold")
    counter(heading).display()
    h(0.7em)
    it.body
  }),
)

#set figure(gap: 0.7em)
#show figure.caption: it => {
  set text(size: 8.8pt)
  set par(justify: true, leading: 0.5em)
  set align(left) if it.kind == image
  [*#it.supplement #context it.counter.display(it.numbering):* #it.body]
}
#show figure.where(kind: table): set figure.caption(position: top)
#show table: set par(justify: false)

/* ---------- Helpers ---------- */

// "_" means a single point in time, "" means ongoing.
#let dates(from, to) = {
  if to == "_" [#from] else if to == "" [#from – present] else [#from – #to]
}

// Small-print period that sits flush right on the entry's first line.
#let period(from, to) = on-web(el("span", class: "period", dates(from, to)), text(size: 9pt, fill: muted, dates(
  from,
  to,
)))

#let org(o) = if o.link == none { o.name } else { link(o.link, o.name) }

// Entry heading: bold title, then "where" with the period flush right, then an optional muted detail line.
#let entry(title, where, when: none, detail: none) = {
  on-web(
    {
      if when != none { period(..when) }
      [*#title* \ #where]
      if detail != none { el("span", class: "detail", detail) }
    },
    {
      [*#title* \ #where]
      if when != none [#h(1em)#h(1fr)#box(period(..when))]
      if detail != none [\ #text(fill: muted, detail)]
    },
  )
}

#let highlights(items) = if items.len() > 0 { list(..items) }

// booktabs: heavy top & bottom rules, light mid rule, no verticals.
#let booktabs(columns: auto, align: auto, header: (), ..rows) = {
  set text(size: 9pt)
  table(
    columns: columns,
    align: align,
    stroke: none,
    inset: (x: 5pt, y: 3.4pt),
    table.hline(stroke: 0.9pt),
    table.header(..header.map(h => [*#h*])),
    table.hline(stroke: 0.5pt),
    ..rows,
    table.hline(stroke: 0.9pt),
  )
}

/* ---------- References (publications, then talks) ---------- */

// Each entry is a numbered `figure` of its own kind, so `@key` renders as "[n]".
#let ref-kind = "reference"
#show figure.where(kind: ref-kind): it => it.body
#show ref: it => {
  let el = it.element
  if el != none and el.func() == figure and el.kind == ref-kind {
    link(el.location(), numbering("[1]", ..counter(figure.where(kind: ref-kind)).at(el.location())))
  } else { it }
}

#let reference(key, body) = [
  #figure(kind: ref-kind, supplement: none, numbering: "1", outlined: false, context {
    let n = counter(figure.where(kind: ref-kind)).get().first()
    on-web(el("div", class: "reference", el("span", class: "ref-num", [[#n]]) + el("span", body)), {
      set align(left)
      set text(size: 9pt)
      grid(
        columns: (1.8em, 1fr),
        [[#n]], body,
      )
    })
  })
  #label(key)
]

#let author-list(authors, max: 6) = {
  let fmt(a) = if a == cv.name [*#a*] else [#a]
  if authors.len() <= max { authors.map(fmt).join(", ", last: " and ") } else {
    authors.slice(0, max).map(fmt).join(", ") + [, et al] // callers add the period
  }
}

/* ---------- Title block ---------- */

#let contacts = (
  link("mailto:" + cv.contact.email, cv.contact.email),
  link("https://github.com/" + cv.contact.github)[github.com/#cv.contact.github],
  link("https://www.linkedin.com/in/" + cv.contact.linkedin)[linkedin.com/in/#cv.contact.linkedin],
  //link("tel:" + cv.contact.phone.replace(" ", ""), cv.contact.phone),
)

#on-web(
  el("header", {
    el("h1", cv.name)
    el("p", class: "subtitle", [Curriculum Vitae])
    el("p", class: "headline", cv.headline)
    el("p", class: "contact", contacts.join[ · ])
    // cv.pdf is deployed next to index.html (see .github/workflows/ci.yml).
    el("p", class: "download", el(
      "a",
      attrs: (href: "cv.pdf", download: cv.name.replace(" ", "-") + "-CV.pdf"),
      [Download PDF],
    ))
    el("div", class: "summary", cv.summary)
  }),
  [
    // #line(length: 100%, stroke: 2.4pt)
    #v(0.1em)
    #align(center)[
      #text(size: 19pt, weight: "bold")[#cv.name] \
      #v(0.35em)
      #text(size: 10.5pt, style: "italic")[Curriculum Vitae]
    ]
    #v(0.25em)
    // #line(length: 100%, stroke: 0.6pt)
    #v(0.15em)
    #align(center, text(size: 9pt)[
      #v(0.2em)
      #cv.headline \
      #v(0.2em)
      #set text(font: "DejaVu Sans Mono", size: 7.5pt, fill: accent)
      #contacts.map(box).join[ #h(0.05em)·#h(0.05em) ]
    ])
    #v(2em)
    #pad(x: 9mm, text(size: 9.5pt, cv.summary))
    #v(2em)
  ],
)

/* ---------- Figure 1: wrapped headshot ---------- */

// Text column : figure = φ : 1 (the same split as the classic two-column variant).
#let fig-gutter = 6mm
#let text-width = 210mm - 2 * 25mm
#let portrait-figure = figure(
  image("images/headshot.jpg", width: 100%, alt: "Portrait of " + cv.name),
  caption: [#cv.about],
)
#let portrait = box(width: (text-width - fig-gutter) / (1 + phi), portrait-figure)

/* ---------- Body ---------- */

#let body = [
  = Education

  #for e in cv.education [
    #entry(e.degree + " " + e.major, org(e.university), when: (e.from, e.to), detail: [#e.track track])
    #parbreak()
  ]

  = Research <sec-research>

  #for e in r.projects [
    #block(sticky: true, below: 0.55em, entry(e.title, [#e.position, #org(e.group)], when: (e.from, e.to)))
    #e.description
    #highlights(e.highlights)
    #parbreak()
    #gap(1em)
  ]

  #entry(r.title, [#r.position, #link(r.group.link, r.group.name)], when: (r.from, r.to)) \
  #gap(0.5em)
  #r.institution, in collaboration with the #r.collaboration; supervised by #r.supervisor.
  #gap(0.5em)
  #r.explainer

]

#let after-wrap = [
  #highlights(r.highlights)

  Results appeared at #cv.publications.map(p => [#p.venue_short #ref(label(p.key))]).join(", ") and were presented at #r.talks.map(t => [#t.event (#t.venue) #ref(label(t.key))]).join(" and ").
  // _Tools:_ #r.tags.join(", ").

  = Publications and Talks

  #for p in cv.publications {
    reference(p.key)[#author-list(p.authors). #link(p.link)[#p.title]. In #emph(p.venue), #p.location, #p.year.]
  }
  #for t in r.talks {
    reference(
      t.key,
    )[#author-list(t.authors). #link(t.link)[#t.title]. Talk at #emph(t.event), #t.venue, #t.date#if t.speaker != cv.name [, presented by #t.speaker].]
  }
]

// Only the text beside the figure goes through meander (it handles plain paragraphs best);
// whatever does not fit next to it overflows into the normal flow below.
#on-web(
  {
    el("div", class: "portrait", portrait-figure)
    body
  },
  meander.reflow({
    import meander: *
    placed(top + right, boundary: contour.margin(left: fig-gutter, bottom: 2mm), portrait)
    container()
    content(body)
  }),
)

#after-wrap

= Experience

#for job in cv.jobs [
  #block(sticky: true, below: 0.55em, entry(job.position, org(job.company), when: (job.from, job.to)))
  #job.description
  #highlights(job.highlights)
  #parbreak()
  #gap(1em)
]

= Teaching

#figure(
  booktabs(
    columns: (1.15fr, 1fr, auto),
    align: (left, left, right),
    header: ([Role], [Course], [Period]),
    ..cv
      .teaching
      .enumerate()
      .map(((i, group)) => (
        (if i > 0 { (table.hline(stroke: 0.3pt),) } else { () })
          + (table.cell(colspan: 3, emph(org(group.institution))),)
          + group.roles.map(role => (role.position, emph(role.course), dates(role.from, role.to))).flatten()
      ))
      .flatten(),
  ),
  caption: [Teaching positions, grouped by institution.],
)

= Projects

#for p in cv.projects [
  #block(sticky: true, below: 0.55em)[*#p.name*: #link(p.link, p.display)#if p.repo != none [ · #link(p.repo)[GitHub]]]
  #p.description
  // #if p.tags.len() > 0 [_Stack:_ #p.tags.join(", ").]
  #parbreak()
  #gap(1em)
]

// = Skills

// #figure(
//   booktabs(
//     columns: (auto, 1fr),
//     align: (left, left),
//     header: ([Area], [Tools]),
//     ..cv.skills.groups.pairs().map(((k, v)) => (k, v.join(", "))).flatten(),
//     table.hline(stroke: 0.3pt),
//     [Spoken languages],
//     cv.skills.languages.join(", "),
//   ),
//   caption: [Technical skills.],
// )
