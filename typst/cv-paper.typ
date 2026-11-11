// Research-paper variant, loosely modelled on a NeurIPS preprint:
// title between rules, abstract, numbered sections, figure, booktabs tables, references.
#import "lib/content.typ": load-cv
#let configuration = load-cv()
#let r = configuration.research

#let accent = rgb("#1f4e79")
#let muted = luma(110)

#set document(title: configuration.name + " – Curriculum Vitae", author: configuration.name)
#set page(
  margin: (x: 28mm, top: 22mm, bottom: 24mm),
  numbering: "1",
  footer: context {
    set text(size: 8pt)
    if counter(page).get().first() == 1 [
      _Curriculum Vitae. Compiled #datetime.today().display("[month repr:long] [year]")._ #h(1fr) #counter(page).display()
    ] else [
      #h(1fr) #counter(page).display() #h(1fr)
    ]
  },
)
#set text(font: "New Computer Modern", size: 10pt)
#set par(justify: true, leading: 0.55em, spacing: 0.75em)
#set par.line(numbering: n => text(size: 6pt, fill: luma(160), str(n)), numbering-scope: "page")
#show link: set text(fill: accent)

#set heading(numbering: "1.1")
#show heading.where(level: 1): it => block(sticky: true, above: 1.4em, below: 0.8em, {
  set text(size: 11.5pt, weight: "bold")
  if it.numbering != none [#counter(heading).display() #h(0.6em)]
  it.body
})
#show heading.where(level: 2): it => block(sticky: true, above: 1em, below: 0.6em, {
  set text(size: 10pt, weight: "bold")
  counter(heading).display() + h(0.6em) + it.body
})
#show table: set par(justify: false)

#set figure(gap: 0.6em)
#show figure.caption: it => {
  set text(size: 9pt)
  set par(justify: true)
  [*#it.supplement #context it.counter.display(it.numbering):* #it.body]
}
#show figure.where(kind: table): set figure.caption(position: top)

// "_" means a single point in time, "" means ongoing.
#let dates(from, to) = {
  if to == "_" [#from] else if to == "" [#from – present] else [#from – #to]
}

// Run-in paragraph heading, as in LaTeX's \paragraph.
#let para(title) = [*#title* #h(0.4em)]

#let highlights(items) = {
  if items != none and items.len() > 0 {
    list(..items.map(h => [#h]))
  }
}

// References: the publication first, then the talks.
#let refs = (
  configuration.publications.map(p => (
    key: p.title,
    body: [#p.authors.map(a => if a == configuration.name [*#a*] else [#a]).join(", "). #link(p.link)[#p.title]. In #emph(p.venue), #p.location, #p.year.],
  ))
    + r.talks.map(t => (
      key: t.title,
      body: [#t.speaker. #link(t.link)[#t.title]. Talk at #emph(t.event), #t.venue, #t.date.],
    ))
)
#let cite-title(title) = {
  let i = refs.position(x => x.key == title)
  link(label("ref-" + str(i + 1)))[[#(i + 1)]]
}

// Schematic inspiral chirp in noise (illustrative, not real data).
#let chirp-figure(width: 100%, height: 2.4cm) = layout(size => {
  let w = if type(width) == ratio { size.width * width } else { width }
  let n = 900
  let tc = 1.0
  let pts-noise = ()
  let pts-signal = ()
  for i in range(n) {
    let t = i / n
    let tau = calc.max(tc - t, 0.004)
    let amp = calc.min(0.12 * calc.pow(tau, -0.25), 0.42)
    let phase = -2 * calc.pi * 14 * calc.pow(tau, 0.625) / 0.625
    let ring = if t > tc - 0.004 { calc.exp(-(t - tc + 0.004) * 220) } else { 1 }
    let s = amp * calc.cos(phase) * ring
    let noise = 0.16 * (calc.fract(calc.abs(calc.sin(i * 12.9898) * 43758.5453)) - 0.5) * 2
    let x = w * t
    pts-signal.push((x, height / 2 - s * height))
    pts-noise.push((x, height / 2 - (s + noise) * height))
  }
  let path(pts, stroke) = curve(
    stroke: stroke,
    curve.move(pts.first()),
    ..pts.slice(1).map(p => curve.line(p)),
  )
  box(width: w, height: height, {
    place(path(pts-noise, 0.4pt + luma(185)))
    place(path(pts-signal, 0.8pt + accent))
    place(bottom + left, line(length: w, stroke: 0.4pt + luma(120)))
    place(bottom + right, dy: -0.4em, text(size: 7pt, fill: muted)[time →])
    place(top + left, text(size: 7pt, fill: muted)[strain $h(t)$])
  })
})

/* ---------- Title block ---------- */

#line(length: 100%, stroke: 3.5pt)
#v(0.2em)
#align(center, text(size: 17pt, weight: "bold")[#configuration.name: Curriculum Vitae])
#v(0.1em)
#line(length: 100%, stroke: 1pt)
#v(0.6em)

#align(center)[
  *#configuration.name* \
  ETH Zürich · #r.group.name, #r.institution \
  #text(font: "DejaVu Sans Mono", size: 8.5pt)[#link("mailto:" + configuration.contact.email)[#configuration.contact.email]] \
  #text(size: 8.5pt)[
    #link("https://github.com/" + configuration.contact.github)[github.com/#configuration.contact.github] ·
    #link("https://www.linkedin.com/in/" + configuration.contact.linkedin)[linkedin.com/in/#configuration.contact.linkedin] ·
    #configuration.contact.phone
  ]
]

#v(0.8em)
#align(center, text(size: 11pt, weight: "bold")[Abstract])
#v(0.2em)
#pad(x: 10mm)[#configuration.summary]

/* ---------- Body ---------- */

= Introduction

#configuration.about

Our contributions are as follows:
- *Research.* Machine learning for gravitational-wave physics with #r.group.name and the #r.collaboration (@sec-research), presented at CERN #cite-title(r.talks.first().title).
- *Publications.* First author of PhyTS, a benchmark for scientific time series at NeurIPS 2026 #cite-title(configuration.publications.first().title).
- *Engineering.* Freelance full-stack software for clients in Zürich (@sec-experience) and independent products (@sec-projects).
- *Teaching.* Four teaching roles across ETH Zürich and TU Wien (@sec-teaching).

= Research: #r.title <sec-research>

#para[Setting.] #r.position at the #link(r.group.link)[#r.group.name], #r.institution, in collaboration with the #r.collaboration and supervised by #r.supervisor (#dates(r.from, r.to)).

#para[Explainer.] #r.explainer

#figure(
  pad(top: 0.6em, chirp-figure()),
  caption: [Schematic binary neutron star inspiral: the signal's frequency and amplitude grow as the stars approach merger (blue), while the detector records it buried in noise (grey). Illustrative, not real data.],
) <fig-chirp>

#para[Contributions.]
#highlights(r.highlights)

#para[Talks.] The detection work was presented at the #r.talks.at(0).event at CERN #cite-title(r.talks.at(0).title)#[;] my colleague Kevin Yoon presented our state-space approach to parameter estimation at the #r.talks.at(1).event #cite-title(r.talks.at(1).title).

#para[Tools.] #r.tags.join(", ").

= Experience <sec-experience>

#for job in configuration.jobs [
  #para[#job.position, #if job.company.link == none [#job.company.name] else [#link(job.company.link)[#job.company.name]] (#dates(job.from, job.to)).]
  #job.description
  #highlights(job.highlights)
  #parbreak()
]

= Teaching <sec-teaching>

All teaching roles are summarised in @tab-teaching. As head teaching assistant for Computer Science II, I coordinated the team of teaching assistants and the exercise classes and prepared exercise material with the lecturers. At TU Wien, I co-developed the Capture the Flag (CTF) challenges for _Security for Systems Engineering_ and supervised students during the competition.

#figure(
  {
    set par.line(numbering: none)
    set text(size: 9pt)
    table(
      columns: (1.1fr, 1fr, auto),
      stroke: none,
      align: (left, left, right),
      inset: (x: 5pt, y: 3.2pt),
      table.hline(stroke: 0.9pt),
      table.header([*Role*], [*Course*], [*Period*]),
      table.hline(stroke: 0.5pt),
      ..configuration
        .teaching
        .enumerate()
        .map(((i, group)) => (
          (if i > 0 { (table.hline(stroke: 0.3pt),) } else { () })
            + (table.cell(colspan: 3, emph(group.institution.name)),)
            + group.roles.map(role => (role.position, role.course, dates(role.from, role.to))).flatten()
        ))
        .flatten(),
      table.hline(stroke: 0.9pt),
    )
  },
  caption: [Teaching positions, grouped by institution.],
) <tab-teaching>

= Projects <sec-projects>

#for p in configuration.projects [
  #para[#p.name (#link(p.link)[#p.display]).] #p.description
  #if p.tags.len() > 0 [_Stack:_ #p.tags.join(", ").]
  #parbreak()
]

= Education

#figure(
  {
    set par.line(numbering: none)
    set text(size: 9pt)
    table(
      columns: (auto, 1.4fr, 1fr, auto),
      stroke: none,
      align: (left, left, left, right),
      inset: (x: 5pt, y: 3.2pt),
      table.hline(stroke: 0.9pt),
      table.header([*Degree*], [*Programme*], [*Institution*], [*Period*]),
      table.hline(stroke: 0.5pt),
      ..configuration
        .education
        .map(e => (e.degree, [#e.major (#e.track)], link(e.university.link, e.university.name), dates(e.from, e.to)))
        .flatten(),
      table.hline(stroke: 0.9pt),
    )
  },
  caption: [Degrees.],
)

= Skills

#para[Languages.] #configuration.skills.languages.join(", ").

#para[Technologies.] #configuration.skills.technologies.join(", ").

#heading(numbering: none)[Acknowledgements]

Research supervised by #r.supervisor, in collaboration with the #r.collaboration. Thanks to all co-authors of PhyTS #cite-title(configuration.publications.first().title).

#heading(numbering: none)[References]

#{
  set text(size: 9pt)
  set par.line(numbering: none)
  for (i, ref) in refs.enumerate() [
    #grid(
      columns: (1.6em, 1fr),
      [[#(i + 1)]], [#ref.body #label("ref-" + str(i + 1))],
    )
    #v(0.2em)
  ]
}
