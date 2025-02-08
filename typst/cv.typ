#let configuration = yaml("configuration.yml")
#let settings = yaml("settings.yml")

#let heading_font = "Poppins"

#set page(margin: 20mm)

#show heading.where(level: 1): it => [
  #set text(size: eval(settings.font.size.heading), font: heading_font, weight: "semibold")
  #it
  #v(0.2em)
]


#set text(size: eval(settings.font.size.body))

#let sidebarSection = {
  [

    /* Headshot */
    #par[
      #figure(image("images/headshot.jpg"), placement: top)
    ]

    #par(justify: true)[

      #par[
        #set text(size: eval(settings.font.size.sidebar))
        Born and raised in Vienna, currently living in Zürich.

        In my free time, I like to code, tinker with electronics, design and make
        furniture, and generally enjoy all types of DIY/maker projects. I am also
        interested in FPV drones, IoT prototyping, 3D printing, tennis, cycling,
        triathlons, and of course, all things computer science.

        *Email:* #link("mailto:contact@benarmstro.ng") \
        *Phone:* #link("tel:+41784215042") \
        *LinkedIn:* #link("www.linkedin.com/in/benedictarmstrong")[benedictarmstrong] \
        *GitHub:* #link("https://github.com/benedict-armstrong")[benedict-armstrong] \
      ]
    ]
  ]
}

#let mainSection = {
  [

    #upper[
      #set text(font: heading_font)
      #[
        #set text(size: 20pt, weight: "medium")
        *Benedict Armstrong*
      ]
      #[
        #set text(size: 10pt)
        #link("mailto:contact@benarmstro.ng")[contact\@benarmstro.ng] #h(1fr)
        // #link("https://benarmstro.ng")[benarmstro.ng]
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
            #place.degree #place.major \
            #place.from — #place.to \
          ]
          #v(1em)
      ]
    }

    = Experience

    #{
      for job in configuration.jobs [
        - #[
            #set text(size: 11pt)
            *#job.position*,
            #link(job.company.link)[#job.company.name] \
            #job.from #if job.to != "_" [— #job.to] \
            #[
              #par[
                #set text(size: eval(settings.font.size.body))
                #job.description
              ]
            ]
            // #{
            //   set text(
            //     size: eval(settings.font.size.tags),
            //   )
            //   let tag_line = job.tags.join(" • ")
            //   tag_line
            // }
          ]
        #v(1em)
      ]
    }

    = Languages and Technologies

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

#{
  grid(
    columns: (1.618fr, 1fr),
    column-gutter: 1em,
    mainSection, sidebarSection,
  )
}
