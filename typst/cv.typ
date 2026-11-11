#import "lib/content.typ": load-cv
#let configuration = load-cv()
#let settings = yaml("settings.yml")

#let heading_font = "Poppins"

#set page(margin: 20mm)

#show heading.where(level: 1): it => [
  #set text(size: eval(settings.font.size.heading), font: heading_font, weight: "semibold")
  #it
  #v(0.2em)
]

#show heading.where(level: 2): it => [
  #set text(size: 12pt, font: heading_font, weight: "medium")
  #it
]

#set text(size: eval(settings.font.size.body))

// "_" means a single point in time, "" means ongoing.
#let dates(from, to) = {
  if to == "_" [#from] else if to == "" [#from — present] else [#from — #to]
}

#let highlights(items) = {
  if items != none and items.len() > 0 {
    list(..items.map(h => [#h]))
  }
}

#let sidebarSection = {
  [

    /* Head-shot */
    #[
      #figure(image("images/headshot.jpg"), placement: top)
    ]

    #set text(size: eval(settings.font.size.sidebar))
    #par(configuration.about, justify: true)
    #[
      *Email:* #link("mailto:" + configuration.contact.email) \
      *Phone:* #link("tel:" + configuration.contact.phone) \
      *LinkedIn:* #link("https://www.linkedin.com/in/" + configuration.contact.linkedin)[#configuration.contact.linkedin] \
      *GitHub:* #link("https://github.com/" + configuration.contact.github)[#configuration.contact.github] \
    ]

    = Projects

    #for project in configuration.projects [
      #link(project.link)[*#project.name*] · #link(project.link)[#project.display] \
      #par(project.description, justify: true)
      #v(0.5em)
    ]

    = Skills

    #{
      let languages = configuration.skills.languages.join(", ")
      let technologies = configuration.skills.technologies.join(", ")
      [
        - #languages
        - #technologies
      ]
    }

  ]
}

#let restSection = {
  [
    = Experience

    #{
      for job in configuration.jobs [
        - #[
            #set text(size: 11pt)
            *#job.position*, #if job.company.link == none [#job.company.name] else [#link(job.company.link)[#job.company.name]] #h(1fr) #dates(job.from, job.to)
            #[
              #par[
                #set text(size: eval(settings.font.size.body))
                #job.description
              ]
            ]
            #highlights(job.highlights)
          ]
        #v(0.6em)
      ]
    }

    = Teaching

    #for group in configuration.teaching [
      #link(group.institution.link)[*#group.institution.name*]
      #for role in group.roles [
        - *#role.position*, _#role.course _ #h(1fr) #dates(role.from, role.to) \
          #role.description
      ]
      #v(0.6em)
    ]

  ]
}

#let mainSection = {
  [

    #upper[
      #set text(font: heading_font)
      #[
        #set text(size: 20pt, weight: "medium")
        *#configuration.name*
      ]
      #[
        #set text(size: 10pt)
        #link("mailto:" + configuration.contact.email)[#configuration.contact.email] #h(1fr)
      ]
    ]
    = Education

    #{
      for place in configuration.education [
        - #[
            #set text(size: 11pt)
            #[
              #link(place.university.link)[*#place.university.name*]
            ] \
            #place.degree #place.major, #place.track track \
            #dates(place.from, place.to) \
          ]
          #v(0.4em)
      ]
    }

    = Research

    #{
      let r = configuration.research
      [
        - #[
            *#r.title*, #r.position \
            #link(r.group.link)[#r.group.name], #r.institution \
            In collaboration with the #r.collaboration · supervised by #r.supervisor \
            #dates(r.from, r.to)
            #par(r.explainer, justify: true)
            #highlights(r.highlights)
          ]
      ]
    }

    == Talks

    #for talk in configuration.research.talks [
      - #link(talk.link)[_#talk.title _] \
        #talk.speaker · #talk.event, #talk.venue, #talk.date
    ]

    = Publications

    #for pub in configuration.publications [
      - #link(pub.link)[*#pub.title*] \
        *#pub.authors.first()*, #pub.authors.slice(1, 3).join(", "), … , #pub.authors.last() (#pub.authors.len() authors) \
        _#pub.venue_short _, #pub.location
      #v(0.6em)
    ]

  ]
}

#{
  grid(
    columns: (1.618fr, 1fr),
    column-gutter: 1em,
    mainSection, sidebarSection,
  )
}

#restSection
