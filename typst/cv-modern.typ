// Modern single-column variant: date rail on the left, accent colour, featured research block.
#import "lib/content.typ": load-cv
#let configuration = load-cv()

#let heading_font = "Poppins"
#let accent = rgb("#1f4e79")
#let muted = rgb("#6b7280")
#let tint = rgb("#eef3f8")

#set page(margin: (x: 18mm, y: 13mm))
#set text(size: 10pt, font: "Source Serif 4")
#set par(leading: 0.5em)
#set list(marker: text(fill: accent)[▸], indent: 0pt, body-indent: 0.5em)
#show link: set text(fill: accent)

// "_" means a single point in time, "" means ongoing.
#let dates(from, to) = {
  if to == "_" [#from] else if to == "" [#from – present] else [#from – #to]
}

#let section(title) = {
  v(0.7em)
  grid(
    columns: (auto, 1fr),
    column-gutter: 0.6em,
    align: horizon,
    text(font: heading_font, size: 11pt, weight: "semibold", fill: accent, tracking: 0.08em, upper(title)),
    line(length: 100%, stroke: 0.6pt + accent.lighten(60%)),
  )
  v(0.3em)
}

// One row on the date rail.
#let entry(when, body) = {
  grid(
    columns: (25mm, 1fr),
    column-gutter: 4mm,
    text(size: 8.5pt, fill: muted, when), body,
  )
  v(0.45em)
}

#let highlights(items) = {
  if items != none and items.len() > 0 {
    list(..items.map(h => [#h]))
  }
}

#let tags(items) = {
  if items != none and items.len() > 0 {
    set text(size: 8pt, fill: accent)
    items.map(t => box(fill: tint, inset: (x: 4pt, y: 2pt), radius: 2pt, t)).join(h(3pt))
  }
}

/* Header */
#grid(
  columns: (1fr, 22mm),
  column-gutter: 6mm,
  align: horizon,
  [
    #text(font: heading_font, size: 24pt, weight: "semibold")[#configuration.name] \
    #v(-0.3em)
    #text(font: heading_font, size: 10pt, fill: accent)[ML for physics · Computational Science & Engineering, ETH Zürich]
    #v(0.2em)
    #set text(size: 9pt)
    #(
      link("mailto:" + configuration.contact.email, configuration.contact.email),
      link("tel:" + configuration.contact.phone, configuration.contact.phone),
      link("https://www.linkedin.com/in/" + configuration.contact.linkedin, "in/" + configuration.contact.linkedin),
      link("https://github.com/" + configuration.contact.github, "gh/" + configuration.contact.github),
    ).map(box).join([ #h(0.3em)·#h(0.3em) ])
  ],
  box(clip: true, radius: 50%, width: 22mm, height: 22mm, image("images/headshot.jpg", width: 22mm, height: 22mm, fit: "cover")),
)

#v(0.4em)
#par(justify: true, text(size: 10pt, configuration.summary))

/* Education */
#section("Education")
#for place in configuration.education {
  entry(dates(place.from, place.to))[
    *#place.degree #place.major* · #link(place.university.link)[#place.university.name] #h(1fr) #text(fill: muted)[#place.track track]
  ]
}

/* Research */
#section("Research")
#{
  let r = configuration.research
  block(fill: tint, inset: 10pt, radius: 4pt, width: 100%)[
    #text(font: heading_font, size: 11pt, weight: "semibold")[#r.title] #h(1fr) #text(size: 8.5pt, fill: muted, dates(r.from, r.to)) \
    #r.position, #link(r.group.link)[#r.group.name], #r.institution \
    #text(fill: muted)[In collaboration with the #r.collaboration · supervised by #r.supervisor]
    #v(0.2em)
    #par(justify: true, r.explainer)
    #highlights(r.highlights)
    #v(0.2em)
    #text(font: heading_font, size: 8.5pt, weight: "semibold", fill: accent)[TALKS]
    #for talk in r.talks [
      \ #link(talk.link)[#talk.title] — #talk.speaker, #emph(talk.event), #talk.venue, #talk.date
    ]
    #v(0.3em)
    #tags(r.tags)
  ]
}

/* Publications */
#section("Publications")
#for pub in configuration.publications {
  entry(pub.year)[
    #link(pub.link)[*#pub.title*] \
    #pub.authors.slice(0, 6).map(a => if a == configuration.name [*#a*] else [#a]).join(", "), …, #pub.authors.last() \
    #emph(pub.venue) (#pub.venue_short), #pub.location
  ]
}

/* Experience */
#section("Experience")
#for job in configuration.jobs {
  entry(dates(job.from, job.to))[
    *#job.position* · #if job.company.link == none [#job.company.name] else [#link(job.company.link)[#job.company.name]] \
    #job.description
    #highlights(job.highlights)
  ]
}

/* Teaching */
#section("Teaching")
#for group in configuration.teaching [
  #grid(columns: (25mm, 1fr), column-gutter: 4mm, [], link(group.institution.link)[*#group.institution.name*])
  #v(0.2em)
  #for role in group.roles {
    entry(dates(role.from, role.to))[
      #role.position · #emph(role.course) \
      #highlights(role.highlights)
    ]
  }
]

/* Projects */
#section("Projects")
#grid(
  columns: (1fr, 1fr),
  column-gutter: 4mm,
  ..configuration.projects.map(p => block(stroke: 0.6pt + accent.lighten(60%), inset: 9pt, radius: 4pt, width: 100%, height: auto)[
    #text(font: heading_font, weight: "semibold")[#p.name] #h(1fr) #link(p.link)[#p.display]
    #v(0.1em)
    #par(justify: true, text(size: 9pt, p.description))
    #tags(p.tags)
  ]),
)

/* Skills */
#section("Skills")
#entry([Languages], configuration.skills.languages.join(", "))
#entry([Technologies], configuration.skills.technologies.join(", "))
