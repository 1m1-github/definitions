#set page(
  width: 15cm,
  height: 7cm,
  margin: 5%,
)
#set text(font: "EB Garamond", size: 12pt)
#set align(center + horizon)

// functions

#import "@preview/cetz:0.4.2"
#import "@preview/suiji:0.4.0": gen-rng, integers, random
#let social-structure(rng, colors, cols, rows, shape, radius, h, w) = {
  figure(
    box(
      height: h,
      width: w,
      {
        let n = cols * rows
        for c in range(0, cols) {
          for r in range(0, rows) {
            let rand_x = 0
            let rand_y = 0
            (rng, rand_x) = random(rng)
            (rng, rand_y) = random(rng)
            let num_ss = ()
            (rng, num_ss) = integers(rng, low: 2, high: colors.len() + 1, size: 1)
            let ss = ()
            (rng, ss) = integers(rng, low: 0, high: colors.len(), size: num_ss.at(0))
            let shape_colors = ()
            for i in ss {
              shape_colors.push(colors.at(i))
            }
            let dx = (c + rand_x / 2) * 100% / cols
            let dy = (r + rand_y / 2) * 100% / rows
            place(
              dx: dx,
              dy: dy,
              shape(rng, shape_colors, radius),
            )
          }
        }
      },
    ),
  )
}
#let vertical-stripes-tiling(colors, radius) = tiling(
  size: (2 * radius, 2 * radius),
)[
  #for (i, color) in colors.enumerate() {
    let stripe-width = 2 * radius / colors.len()
    place(
      dx: i * stripe-width,
      rect(
        width: 100%,
        height: 100%,
        fill: color,
      ),
    )
  }
]
#let vertical-stripes-shape(_, colors, radius) = {
  circle(
    radius: radius,
    fill: vertical-stripes-tiling(colors, radius),
  )
}
#let empty-fill-shape(_, _, radius) = {
  circle(
    radius: radius,
  )
}
#let some-fill-shape(rng, colors, radius, p-fill, p-square) = {
  let rand_fill = 0
  (rng, rand_fill) = random(rng)
  if p-fill < rand_fill { return circle(radius: radius) }
  let rand_shape = 0
  (rng, rand_shape) = random(rng)
  if rand_shape < p-square {
    square(
      size: 2 * radius,
      fill: black,
    )
  } else {
    circle(
      radius: radius,
      fill: black,
    )
  }
}
#let rng = gen-rng(42)
#let colors = (black, green, red, yellow, blue)
#let circle_radius = 2mm

#let title(x, s) = place(top + center, strong(text(
  size: s,
)[#x]))

#let bowers(bowing, founder) = cetz.canvas({
  import cetz.draw: *
  let size = (10, 4)
  let fixed_length = 0.5
  rect((0, 0), (rel: size))
  let house_size = calc.min(size.at(0), size.at(1)) / 10
  let center = (size.at(0) / 2, size.at(1) / 2)
  let house_bottom_left = (center.at(0) - house_size / 2, center.at(1) - house_size / 2)
  rect(house_bottom_left, (rel: (house_size, house_size)))
  if founder {
    content(center, text(size: 10pt)[$bold(MM)$])
  }
  let bower(p) = {
    let direction = (center.at(0) - p.at(0), center.at(1) - p.at(1))
    let length = calc.sqrt(direction.at(0) * direction.at(0) + direction.at(1) * direction.at(1))
    if 0 < length {
      let unit_direction = (direction.at(0) / length, direction.at(1) / length)
      let offset = (unit_direction.at(0) * fixed_length, unit_direction.at(1) * fixed_length)
      let end_pt = (p.at(0) + offset.at(0), p.at(1) + offset.at(1))
      let house_top_right = (center.at(0) + house_size / 2, center.at(1) + house_size / 2)
      if not (
        house_bottom_left.at(0) <= end_pt.at(0)
          and house_bottom_left.at(1) <= end_pt.at(1)
          and end_pt.at(0) <= house_top_right.at(0)
          and end_pt.at(1) <= house_top_right.at(1)
      ) {
        if bowing {
          line(p, end_pt, mark: (end: "circle"))
        } else {
          circle(p, radius: 0.1)
        }
      }
    }
  }
  let rows = 10
  let cols = 7
  let dx = size.at(0) / (rows + 1)
  let dy = size.at(1) / (cols + 1)
  for x in range(rows) {
    for y in range(cols) {
      bower((dx * (x + 1), dy * (y + 1)))
    }
  }
})

#let highlight(a) = box(stroke: (paint: red, thickness: 2pt), inset: 5pt)[#a]

#let Evil(highlight_what) = {
  let evil = $ S "is" bold(bb(e)"vil") <=> S "is" bold("provably") bb(b)"ad" $
  let Evil = $ S "is" bold(EE"vil") <=> Delta"Health"(W-S) = min_(bb(e)"vil" S') Delta"Health"(W-S') $
  let virus = [An $bb(e)$vil social structure is a *social $bb(v)$irus* inside the individual]
  if highlight_what == "evil" { evil = highlight(evil) } else if highlight_what == "Evil" {
    Evil = [#highlight(Evil) #v(0%)]
  } else if highlight_what == "virus" { virus = highlight(virus) }

  title($EE"vil"$, 25pt)
  text(size: 13pt)[
    #evil
    #Evil
  ]
  text(size: 15pt)[
    #virus
  ]
}

#let Cult(highlight_what) = {
  let leverage = $arrow.b$
  let censorship = $arrow.t$
  let life = "life"
  if highlight_what == "life" {
    life = highlight(life)
  } else if highlight_what == "leverage" {
    leverage = highlight(leverage)
  } else if highlight_what == "censorship" {
    censorship = highlight(censorship)
  }

  title($bold("Cult")(S) = "Cost-of-Exit"(S)$, 25pt)
  cetz.canvas(
    length: 67mm,
    {
      import cetz.draw: *
      let a = 0.02
      let b = 0.10
      let value_font_size = 10pt
      line((0, 0), (2, 0), stroke: (paint: black, thickness: 1pt))
      line((0, a), (0, -a), stroke: (paint: black, thickness: 1pt))
      content((0, -2 * a), anchor: "north", "0")
      line((2, a), (2, -a), stroke: (paint: black, thickness: 1pt))
      content((2, -2 * a), anchor: "north", life)
      line((0, a), (0, -a), stroke: (paint: black, thickness: 1pt))
      content((0, b), anchor: "north", text(size: value_font_size)[Cult$(S_A)$])
      line((0.5, a), (0.5, -a), stroke: (paint: black, thickness: 1pt))
      content((0.5, b), anchor: "north", text(size: value_font_size)[Cult$(S_B)$])
      line((1.5, a), (1.5, -a), stroke: (paint: black, thickness: 1pt))
      content((1, b), anchor: "north", "...")
      content((1.5, b), anchor: "north", text(size: value_font_size)[Cult$(S_C)$])
      line((2, a), (2, -a), stroke: (paint: black, thickness: 1pt))
      content((2, b), anchor: "north", text(size: value_font_size)[Cult$(S_D)$])
    },
  )
  table(
    columns: (0.9fr, 0.9fr, 0.9fr),
    align: (horizon + center, center, horizon + center),
    [Cult(S)], [Cult(S) Secrecy], [\#Enforcers$div$\#Individuals],
    [$arrow.t$], [#censorship], [#leverage],
    [$arrow.b$], [$arrow.b$], [$arrow.t$],
  )
}

#let DeathCult(highlight_what) = {
  let no-exit = $S "is a" #strong($DD"eath Cult"$) <=> "Cult"(S) = "Life" <=> bold("No-Exit")$
  let secret = $=> S "is a" DD"eath Cult" => "No-Exit has to be fully" bold("secret")$
  let deceive = $=> I in S_(DD"eath Cult") "is" bold("forced") "to" bb(d)"eceive"$
  let duress = $=> "All statements by" I in S_(DD"eath Cult") "about" S_("Death Cult") "are under" #strong($bb(d)"uress"$)$
  if highlight_what == "no-exit" {
    no-exit = highlight(no-exit)
  } else if highlight_what == "secret" {
    secret = highlight(secret)
  } else if highlight_what == "deceive" {
    deceive = highlight(deceive)
  } else if highlight_what == "duress" {
    duress = highlight(duress)
  }

  title($DD"eath Cult"$, 25pt)
  v(10%)
  [#no-exit]
  v(0%)
  [#secret]
  v(0%)
  [#deceive]
  v(0%)
  [#duress]
  v(10%)
  $ S_("Death Cult") "intends to be an informational" bold("black hole") "pretending differently" $
}

#let Submission(highlight_what) = {
  let child_slavery = $ I in SS => #strong("progeny") (I) subset SS $
  let sexual_slavery = $ "No" #strong("sexual consent") "for XX" $
  if highlight_what == "child_slavery" {
    child_slavery = highlight(child_slavery)
  } else if highlight_what == "sexual_slavery" {
    sexual_slavery = highlight(sexual_slavery)
  }

  title($EE"vil" = SS"ubmission"$, 25pt)
  text(size: 15pt)[
    #child_slavery
    #sexual_slavery
  ]
}

#let Slavery(highlight_what) = {
  let child_slavery = [$I$ do not own my own consent #linebreak() $<=> I$ cannot freely choose my $S$ membership]
  let sexual_slavery = [$I$ do not own my own sexual consent #linebreak() $<=> I$ cannot freely choose my sex partner]
  let big = text(size: 25pt)[*Sexual $SS$lavery*]

  if highlight_what == "child_slavery" {
    child_slavery = highlight(child_slavery)
  } else if highlight_what == "sexual_slavery" {
    sexual_slavery = highlight(sexual_slavery)
  }

  title($SS"lavery"$, 25pt)
  text(size: 15pt)[
    #v(15%)
    #child_slavery
    #v(0%)
  ]
  big
  text(size: 15pt)[
    #v(0%)
    #sexual_slavery
    #v(0%)
  ]
}

#let Mass-Rape(show-stats) = {
  let stats = ""
  if show-stats {
    stats = highlight([
      #v(5%)
      $approx$ #strong($10^8$) $SS$ubmitted XX are $bold(bb(r))$*aped daily* in silence
    ])
  }

  title($"Mass" RR"ape"$, 25pt)
  v(10%)
  text(size: 15pt)[
    *"marriage"* under $SS$ubmission
    #v(10%)
    $ <=> I_"XX" != "\"guardian\""_T (I_"XX") != "\"guardian\""_(T + Delta T) (I_"XX") != I_"XX" $
    #stats
  ]
}

#let ExMuslims(highlight_what) = {
  let fraction = $ (\#"Ex"MM attach(SS, bl: "u")"L"_i"Ms")/(\# MM attach(SS, bl: "u")"L"_i"Ms") approx 1/4 $
  if highlight_what == "fraction" {
    fraction = highlight(fraction)
  }

  title($MM attach(SS, bl: "u")"L"_i"Ms" "Are Forced To Be" MM attach(SS, bl: "u")"L"_i"M"$, 21pt)
  v(15%)
  text(size: 14pt)[
    Born $MM attach(SS, bl: "u")"L"_i"Ms"$ *never* get to consent
    // #v(0%)
    #linebreak()
    $MM attach(SS, bl: "u")"L"_i"Ms"$ deserve a choice
    #v(1%)
    // #linebreak()
    *Ex*$#strong($MM attach(SS, bl: "u")"L"_i"Ms"$)$ are aware of being trapped in a $DD$eath Cult
    #v(1%)
    #fraction
  ]
}

#let Submission-Vs-Collectivism(highlight_what) = {
  let Submission = [$SS$ubmission is using #text(fill: red)[$CC$ollectivism] to *destroy* the free world #linebreak() because $SS$ubmission is much $bb(d)$eadlier and bigger]
  if highlight_what == "Submission" {
    Submission = highlight(Submission)
  }

  title($bb(S)"ubmission vs" #text(fill: red)[$CC$ollectivism]$, 25pt)
  v(10%)
  [#text(fill: red)[*$CC$ollectivism*] is using $SS$ubmission to *destroy* the free world]
  v(5%)
  [and, more precisely,]
  v(5%)
  [#Submission]
  v(10%)
  [#text(fill: red)[$CC$ollectivism] = {$CC$ommunism, $SS$ocialism, ...}]
}

#let Death-of-a-Death-Cult(highlight_what) = {
  let save-individuals = $ SS in I thick bb(d)"ies" => I in.not SS bold("and") I in W $
  let destroy-structure = $ forall I in W: I in.not SS => SS in.not W $
  if highlight_what == "save-individuals" {
    save-individuals = highlight(save-individuals)
  } else if highlight_what == "destroy-structure" {
    destroy-structure = highlight(destroy-structure)
  }

  title($DD"eath of a" DD"eath Cult"$, 25pt)
  text(size: 15pt)[
    The $DD$eath Cult will *flight* xor *fight* xor *$bb(d)$ie*
    #save-individuals
    #destroy-structure
  ]
}

#let World(highlight_what) = {
  let no-S = $ W-S = {S_1,...,S_2,I_1,...,I_N,...} "is" W bold("without") S , thick "same" I $
  if highlight_what == "no-S" {
    no-S = text(size: 14pt)[#highlight(no-S)]
  }

  title("World", 25pt)
  v(10%)
  text(size: 15pt)[
    $ exists thin i => i in W $
    $ W = {S_1,...,S,...,S_N,I_1,...,I_N,...} $
    #no-S
  ]
}

#let Health(highlight_what) = {
  let bad = $ S "is" #strong($bb(b)"ad"$) <=> Delta"Health"(W-S) < 0 $
  let lifespan = $ bold("Health") = bb(E)["Lifespan"] $

  if highlight_what == "bad" {
    bad = highlight(bad)
  } else if highlight_what == "lifespan" {
    lifespan = highlight(lifespan)
  }

  title("Health", 25pt)
  v(10%)
  text(size: 14pt)[
    $ bold("Lifespan")(i) = Delta"T such that" i in W $
    #lifespan
    $ S "is" bold("good") <=> 0 < bold(Delta)"Health"(W-S) = "Health"(W) - "Health"(W-S) $
    #bad
  ]
}

#let Religion(highlight_what) = {
  let both = [$bb(S)$ubmission can be a religion *and* the largest $DD$eath Cult]

  if highlight_what == "both" {
    both = highlight(both)
  }

  title("Religion", 25pt)
  v(10%)
  text(size: 15pt)[
    Teachings about God
    \ \
    #both
  ]
}

#let Information(highlight_what) = {
  let everything-is-information = [*Everything* is information and all information *wants* to exist]
  if highlight_what == "everything-is-information" {
    everything-is-information = highlight(everything-is-information)
  }

  title($"Information" bold(i)$, 25pt)
  v(15%)
  text(size: 11pt)[
    $ "Something exists" <=> exists thick bold("1") $
    $ "Something else also exists" <=> exists thin i : i != 1 => exists thick bold("0") $
    New information via *Union*
    $ 1 union 0 arrow.r.long 10 $
    $ 10 union 0 arrow.r.long 100 $
    $ dots.v $
  ]
  [#everything-is-information]
}

#let female_radius = 7mm
#let female_text_size = 23pt
#let female_visible = circle(
  radius: female_radius,
)[
  #set align(center + horizon)
  #text(size: female_text_size)[XX]
]
#let female_partially_visible = circle(
  radius: female_radius,
  fill: tiling(size: (female_radius, female_radius * 4 / 3), [
    #rect(
      width: 100%,
      height: 55%,
      fill: black,
    )
  ]),
)[
  #set align(center + horizon)
  #text(size: female_text_size)[XX]
]
#let female_invisible = circle(radius: female_radius, fill: black)

#let Sexual-Consent(highlight_what) = {
  let guardian = [
    $ forall I_"XX" in H thick thick exists thick I_"XY" = bold("\"guardian\"") in SS"ubmission": $
    $ bold("owner")("sexual consent"( I_"XX" )) = I_"XY" != I_"XX" $
  ]
  let rape = [
    $ => I "cannot consent to sex" => I "did not consent to sex" $
    $ => forall I in SS"ubmission": "sex"=bb(r)"ape" $
  ]
  if highlight_what == "guardian" {
    guardian = highlight(guardian)
  } else if highlight_what == "rape" {
    rape = highlight(rape)
  }

  title("Sexual Consent", 25pt)
  [*Voluntary agreement to sex*]
  v(5%)
  [#guardian]
  [#rape]
}

#let Muslim(highlight_what) = {
  let M = [$MM$ohammed]
  if highlight_what == "M" {
    M = highlight(M)
  }

  let slm = $attach(SS, bl: "u")"L"_i"M"$
  let slm2 = math.underbracket(slm, text(size: 12pt)[$SS$ubmission])
  let muslim = $underbracket(MM, #text(size: 12pt)[#M]) thin #slm2$

  title(muslim, 25pt)
  v(30%)
  [An individual that *$SS$ubmits* to $MM$]
  linebreak()
  [All *criticism* of $MM$ is punishable by $bb(d)$*eath*]
  linebreak()
  [All $SS$ubmitted are *supposed* to follow the *example* of $MM$]
  linebreak()
  [$MM$ ordered the *$bb(g)$enocide* of the people of the XX that *$bb(p)$oisoned* him to $bb(d)$eath]
  linebreak()
  [$MM$ allowed *sex $bb(s)$lavery* and $bold(bb(r))$*aped* a *minor* (< 10 years old) at nearly 10x her age]
  v(1%)
  [$MM$ even hated and genocided *dogs*]
}

#let Censorship-Hides-Evil(highlight_what) = {
  let condition = $ => bb(e) "can convince the Enforcers that" i = \"bb(e) "is" bb(e)"vil"\" $
  if highlight_what == "e is evil" {
    condition = highlight(condition)
  }

  title($underbrace(CC"ensorship") "Hides "bb(e)"vil"$, 25pt)
  v(0%)
  text(size: 15pt)[
    To stop *consenting* entities from exchanging information
    $ i in CC "and" bb(e) "is" bb(e)"vil" $
    #condition
  ]
}

#let Censorship-Reduces-Health(highlight_what) = {
  let condition = $ 0 < Delta_T"Health"(W) => 0 < Delta_T"Complexity"(W) $
  if highlight_what == "condition" {
    condition = highlight(condition)
  }

  title($CC"ensorship Reduces Health"$, 25pt)
  v(10%)
  condition
  v(0%)
  table(
    columns: (0.9fr, 0.6fr, 0.6fr),
    align: (horizon + center, center, horizon + center),
    [$CC$ensorship], [Complexity], [Health],
    [$arrow.t$], [$arrow.b$], [$arrow.b$],
    [$arrow.b$], [$arrow.t$], [$arrow.t$],
  )
}

#let Death-Cults-Are-evil(highlight_what) = {
  let condition = [Full secrecy of No-Exit needs #strong($CC$)ensorship]
  if highlight_what == "secrecy" {
    condition = highlight(condition)
  }

  title($DD"eath Cults Are" bb(e)"vil"$, 25pt)
  v(0%)
  text(size: 15pt)[
    #condition
    \ \
    $DD$eath Cults deny their members *Freedom*
    \ \
    #strong($EE"vil"$) is the largest $DD$eath Cult of the World
  ]
}

#let Act-Now(highlight_what) = {
  let urgent = [The *cost* of destroying $SS$ubmission *increases* over time]
  if highlight_what == "urgent" {
    urgent = highlight(urgent)
  }

  title("Act Now", 25pt)
  v(0%)
  text(size: 15pt)[
    $ \#SS"ubmission" approx underbracket(O(3^T) >> O(2^T), Delta="sexual consent") approx \#"World" $
    \
    #urgent
  ]
}

#let To-Be-Human-Is-To-Err(highlight_what) = {
  let deceived = [You *could* be wrong and *deceived*]
  if highlight_what == "deceived" {
    deceived = highlight(deceived)
  }

  title("To Be Human Is To Err", 25pt)
  v(0%)
  text(size: 15pt)[
    You are *not* God
    \ \
    #deceived
    \ \
    Take a *meta* step back to check
  ]
}

#let Conflict(highlight_what) = {
  let intent = [*intent* matters]
  if highlight_what == "intent" {
    intent = highlight(intent)
  }

  title("Conflict", 25pt)
  [
    \
    $ arrow.r = #strong($bb(g)"enocide"$) = "the" bold("intent") "to destroy all individuals in a social structure" $
    $ S_(bb(a)"buser and victim") arrows.lr tilde(S)_(bb(a)"buser and victim") $
    $ approx $
    $ S_(bb(d)"eceptive" bb(a)"buser") arrow.r S_("victim") $
    \
    #intent
  ]
}

#let Brainwashing(highlight_what) = {
  let children = [Children *trust* guardians]
  if highlight_what == "children" {
    children = highlight(children)
  }

  title("Brainwashing", 25pt)
  text(size: 13pt)[
    \
    #children
    \ \
    $H$ could require all $I$ to view some specific information $i_("chosen")$ regularly
    \
    $i_("chosen")$ begotten via voting or from a random individual and short
  ]
}

#let The-Good-Future(highlight_what) = {
  let ban = text(size: 12pt)[
    *Ban* $SS$ubmission and *send* the adamant to be together
    \ \
  ]
  let center = text(size: 10pt)[
    Only $SS$ubmission *created current* country
    \
    Only $SS$ubmission *ruled nuclear* country
    \
    $=>$ Modern *center* of $SS$ubmission
  ]
  if highlight_what == "ban" {
    ban = highlight(ban)
  } else if highlight_what == "center" {
    center = highlight(center)
  }

  title("The Good Future", 25pt)
  v(0%)
  table(
    columns: (0.6fr, 0.9fr),
    stroke: none,
    [
      #ban
      #center
    ],
    figure(image("Countries Created for Submission map.png", height: 80%)),
  )
}

#let ExMuslim-Apartheid(highlight_what) = {
  let void = text(size: 13pt)[
    Void these Laws to start a Tsunami of Freedom
  ]

  if highlight_what == "void" {
    void = highlight(void)
  }

  title($"Ex"MM attach(SS, bl: "u")"L"_i"M " AA"partheid"$, 25pt)
  v(0%)
  table(
    columns: (0.6fr, 0.9fr),
    stroke: none,
    void, figure(image("ExMuslim Apartheid.png", height: 80%)),
  )
}

#let Mutilation(highlight_what) = {
  let self-consent = [Requires *self-consent* and only adults can consent]

  if highlight_what == "self-consent" {
    self-consent = highlight(self-consent)
  }

  title($MM"utilation"$, 25pt)
  [
    \
    *Permanent abnormal change*
    #text(size: 15pt)[
      \ \ \
      #self-consent
      \ \
      $approx bold("60000")$ $SS$ubmission based $bb(m)$utilations *daily*
    ]
  ]
}

#let Free-Speech(highlight_what) = {
  let max = [*Maximizes* information flow, *purges* $bb(e)$vil and is costly to *protect*]

  if highlight_what == "max" {
    max = highlight(max)
  }

  title("Free Speech", 25pt)
  [
    #max
    \ \
    *Violence* is intentional, physical harm
    \ \
    *Not* convincing people does *not* justify violence
    \ \
    The *punishment* for deception should be proportional to the *damage*
  ]
}

#let Armed-Forces(highlight_what) = {
  let protect = [The entity with the purpose of *protecting free speech*]
  let arrest = [Always *arrest* the $bb(a)$buser, else $bb(e)$vil can use groups]
  if highlight_what == "protect" {
    protect = highlight(protect)
  } else if highlight_what == "arrest" {
    arrest = highlight(arrest)
  }

  title("Armed Forces", 25pt)
  text(size: 14pt)[
    \ \
    #protect
    \
    1 Armed Forces / *country*
    $ I in.not "Armed Forces" => I in bold("Civilians") $
    #arrest
    \ \
    For real power, *join* the Armed Forces
  ]
}

#let Social-Peace(highlight_what) = {
  let unprecedented = [Removing $SS$ubmission from the world would result in *unprecedented social peace*]

  if highlight_what == "unprecedented" {
    unprecedented = highlight(unprecedented)
  }

  title("Social Peace", 25pt)
  text(size: 15pt)[
    \
    $ Delta"Health"(W-SS) = min_(S in W) Delta"Health"(W-S) $
    #unprecedented
    \ \
    We *could* only have to contend with *non-human threats*
    \
    which are substantial and plenty
  ]
}

#let How-to-Recognize-evil(highlight_what) = {
  let censors = [Whoever *censors* you or suggests *violence* is $bb(e)$vil]

  if highlight_what == "censors" {
    censors = highlight(censors)
  }

  title($"How to Recognize" bb(e)"vil"$, 25pt)
  [
    \ \
    #text(size: 15pt)[
      #censors
      \ \ \
    ]
    #text(size: 13pt)[
      unless you are part of non-$bb(e)$vil Armed Forces and a superior commands it
    ]
  ]
}

#let Name-the-Problem(highlight_what) = {
  let Submission = text(size: 15pt)[$SS$ubmission = #math.attach($SS$, bl: "i") $L_a M$]

  if highlight_what == "Submission" {
    Submission = highlight(Submission)
  }

  title("Name the Problem", 25pt)
  [
    \
    #figure(image("Submission symbol.png", width: 5%))
    #Submission
    \ \ \
    Rather than the agents of $SS$ubmission that are *currently* most problematic
  ]
}

#let Financing(highlight_what) = {
  let convo = table(
    columns: 3,
    row-gutter: 5%,
    stroke: none,
    align: (right, center, left),
    [$SS$ubmission], [:], ["Pay me to protect you."],
    [You], [:], ["To protect from whom?"],
    [$SS$ubmission], [:], ["From me!"],
  )

  if highlight_what == "convo" {
    convo = highlight(convo)
  }

  title("Financing", 25pt)
  [
    \ \
    #text(size: 15pt)[
      *Protection $RR$acket*
    ]
    \ \
    #convo
  ]
}

#let Schools-Of-Knowledge(highlight_what) = {
  let math = [*Mathematics* is the *study* of *information*
    \
    and the most *precise language* for the interpretation of information]
  let science = [*Best* is based on Reliability (Statistics) and Learning called *Science*]

  if highlight_what == "science" {
    science = highlight(science)
  } else if highlight_what == "math" {
    math = highlight(math)
  }

  title("Schools Of Knowledge", 25pt)
  [
    \
    $ "Competition" = bold("Optimization") => "Maximizes World Complexity" $
    \
    #text(size: 14pt)[
      #science
      \ \
      #math
    ]]
}

#let Highscores-Are-Isotone(highlight_what) = {
  let theory = $ "Most" bold("reliable") "current knowledge is called" bold("Theory") $

  if highlight_what == "theory" {
    theory = highlight(theory)
  }

  title("Highscores Are Isotone", 25pt)
  [
    \
    #theory
    $ "An" bold("idea") "to increase reliability is called a" bold("Hypothesis") $
    $ 0 < Delta_T"reliability"(W) => 0 < Delta_T"complexity"(W) $
    $ "reliability"("Theory"_T) <= "reliability"("Theory"_(T + Delta T)) $
  ]
}

#let Natural-Advantage-for-the-Good(highlight_what) = {
  let advantage_up = $arrow.t$
  let advantage_down = $arrow.b$

  if highlight_what == "advantage" {
    advantage_up = highlight(advantage_up)
    advantage_down = highlight(advantage_down)
  }

  title("Natural Advantage for the Good", 25pt)
  v(10%)
  table(
    columns: (0.9fr, 0.6fr, 0.6fr),
    align: (horizon + center, center, horizon + center),
    [\#$SS$ubmission$div$\#Individuals], [Complexity], [Health and Wealth],
    [#advantage_up], [#advantage_down], [#advantage_down],
    [$arrow.b$], [$arrow.t$], [$arrow.t$],
  )
}

#let Best-Individual-Ever(highlight_what) = {
  let declare = [Ask all to *publicly* declare a choice]
  let current_best = [Individual with the highest votes today: *Jesus* of Nazareth]

  if highlight_what == "declare" {
    declare = highlight(declare)
  } else if highlight_what == "current_best" {
    current_best = highlight(current_best)
  }

  title("Best Individual Ever", 25pt)
  [
    \ \
    #text(size: 15pt)[
      #declare
      \ \
      This *discerns* and *unifies* at the same time
      \ \
      #current_best
    ]]
}


#let Complexity(highlight_what) = {
  let purpose = $ bold("Purpose")": Complexity"(W_T) < "Complexity"(W_(T + Delta T)) $

  if highlight_what == "purpose" {
    purpose = highlight(purpose)
  }

  title("Complexity", 25pt)
  v(10%)
  text(size: 14pt)[
    All information can be represented as a *boolean circuit*
    $ bold("Complexity")(i) = min_("circuit"=i) \#"gates" $
    $ "Complexity"(i) <= "Complexity"(i union i') $
    #purpose
  ]
}

#let fin(highlight_what) = {
  let share = [*You need to share*]

  if highlight_what == "share" {
    share = highlight(share)
  }

  [
    This is the most censored and important information for our World
    \ \
    #share
    \ \
    #text(size: 20pt)[tsunamioffreedom.org]
    \ \
    #box(stroke: 1pt + black, height: 35%, width: 100%)[
      Self-Defense
      #align(left)[
        $thin$ This information *cannot* be destroyed $=>$ Harming/killing me is useless
        \
        $thin$ Harm/kill me $=>$ This information goes super *viral* $=>$ i wins
      ]
    ]]
}

// functions

// pagename=Why All the Social Unrest?
#title("Why All the Social Unrest?", 25pt)

#pagebreak()
// pagename=Why All the Social Unrest? Root of Evil
#title("Why All the Social Unrest?", 25pt)
$ #text(size: 20pt)[$sqrt(bb(E)"vil")$] $
#place(bottom + left)[$0 < Delta bold("T")"ime"$]

#pagebreak()
// pagename=Information
#Information("")
#pagebreak()
// pagename=Information everything-is-information
#Information("everything-is-information")

#pagebreak()
// pagename=Reliability
#title("Reliability", 25pt)
\
#text(size: 14pt)[
  $ i_(bold("Input")) arrow.r.long_(i_(bold("Next"))) i_(bold("Output")) $
  $ bold("Error") = || i_(bold("Knowledge")) - i_("Next") || $
  $ bold("Reliability") = "Error"^(-1) $
]

#pagebreak()
// pagename=Complexity
#Complexity("")
#pagebreak()
// pagename=Complexity purpose
#Complexity("purpose")

#pagebreak()
// pagename=Individuals
#title($"Individuals" bold(I)$, 25pt)
\
#social-structure(rng, colors, 10, 8, empty-fill-shape, circle_radius, 50%, 100%)
\
#box[
  #circle(radius: circle_radius)
] #text(size: 14pt)[Inputs, outputs and keeps private information *allowing deception*]

#pagebreak()
// pagename=Social Structure
#title($"Social Structure" bold(S)$, 25pt)
\
#social-structure(
  rng,
  colors,
  10,
  8,
  (rng, colors, radius) => some-fill-shape(rng, colors, radius, 0.25, 0),
  circle_radius,
  50%,
  100%,
)
\
#box[
  #circle(radius: circle_radius, fill: black)
] #text(size: 14pt)[*Members* of a social structure with invisible, informational binding]

#pagebreak()
// pagename=Rules
#title($"Rules: "#text(size: 20pt)[Cost-of-Entry],#text(size: 15pt)[...],#text(size: 20pt)[Cost-of-Exit]$, 20pt)
\
#social-structure(
  rng,
  colors,
  10,
  8,
  (rng, colors, radius) => some-fill-shape(rng, colors, radius, 0.25, 0.2),
  circle_radius,
  50%,
  100%,
)
\
#box(height: 1em, width: auto)[
  #square(size: 2 * circle_radius, fill: black)
] #text(size: 14pt)[A subset of the individuals are *Enforcers* of the rules]

#pagebreak()
// pagename=Social Structures
#title("Social Structures", 25pt)
\
#social-structure(
  rng,
  colors,
  10,
  8,
  vertical-stripes-shape,
  circle_radius,
  50%,
  100%,
)
\
#box(height: 1em, width: auto)[
  #vertical-stripes-shape(rng, colors, circle_radius)
] #text(size: 14pt)[Individuals belong to multiple social structures vying for attention]

#pagebreak()
// pagename=World
#World("")
#pagebreak()
// pagename=World no-S
#World("no-S")

#pagebreak()
// pagename=Health
#Health("")
#pagebreak()
// pagename=Health lifespan
#Health("lifespan")
#pagebreak()
// pagename=Health bad
#Health("bad")

#pagebreak()
// pagename=Evil
#Evil("")
#pagebreak()
// pagename=Evil evil
#Evil("evil")
#pagebreak()
// pagename=Evil virus
#Evil("virus")
#pagebreak()
// pagename=Evil capital Evil
#Evil("Evil")

#pagebreak()
// pagename=Cost-of-Entry
#title($"Cost-of-Entry"(S)$, 25pt)
#text(size: 15pt)[$ I in S => I "knows Cost-of-Entry"(S) $]
#text(size: 13pt)[$ => S "cannot hide Cost-of-Entry"(S) "from" I $ ]

#pagebreak()
// pagename=Cult
#Cult("")
#pagebreak()
// pagename=Cult life
#Cult("life")
#pagebreak()
// pagename=Cult leverage
#Cult("leverage")
#pagebreak()
// pagename=Cult censorship
#Cult("censorship")

#pagebreak()
// pagename=DeathCult
#DeathCult("")
#pagebreak()
// pagename=DeathCult no-exit
#DeathCult("no-exit")
#pagebreak()
// pagename=DeathCult secret
#DeathCult("secret")
#pagebreak()
// pagename=DeathCult deceive
#DeathCult("deceive")
#pagebreak()
// pagename=DeathCult duress
#DeathCult("duress")

#pagebreak()
// pagename=Censorship Hides evil
#Censorship-Hides-Evil("")
#pagebreak()
// pagename=Censorship Hides evil e is evil
#Censorship-Hides-Evil("e is evil")

#pagebreak()
// pagename=Censorship Reduces Health
#Censorship-Reduces-Health("")
#pagebreak()
// pagename=Censorship Reduces Health condition
#Censorship-Reduces-Health("condition")

#pagebreak()
// pagename=Death Cults Are evil
#Death-Cults-Are-evil("")
#pagebreak()
// pagename=Death Cults Are evil secrecy
#Death-Cults-Are-evil("secrecy")

#pagebreak()
// pagename=Solution
#title("Solution", 25pt)
\
#text(size: 13pt)[
  $ S "is" thick DD"eath Cult" => "No-Exit is secret" $
  $ <=> "No-Exit is" #strong("not") "secret" => S "cannot be a" DD"eath Cult" $
]
#text(size: 15pt)[
  #box(stroke: 2pt + red, height: 10%, width: 60%)[$ "Reveal No-Exit" => "no" DD"eath Cult" $]
  \
  Members of a $DD$eath Cult *need saving* from non-members
  \ \
  WARNING ...
]

#pagebreak()
// pagename=Death-of-a-Death-Cult
#Death-of-a-Death-Cult("")
#pagebreak()
// pagename=Death-of-a-Death-Cult save-individuals
#Death-of-a-Death-Cult("save-individuals")
#pagebreak()
// pagename=Death-of-a-Death-Cult destroy-structure
#Death-of-a-Death-Cult("destroy-structure")

#pagebreak()
// pagename=Ban All Death Cults
#title($"Ban All" DD"eath Cults"$, 25pt)
\ \
#figure(image("USA flag.png", width: 25%))
\
#text(size: 13pt)[
  Lest members of a $DD$eath Cult legally *sue* the government
  \
  for allowing the $DD$eath Cult to operate which *denies* the members' Freedom
  \
  (1st Amendment)
]

#pagebreak()
// pagename=Humanity
#title("Humanity", 25pt)
\ \
#text(size: 15pt)[
  $ "Humanity" H = {S_1,...,S_N,I_1,...,I_N,...} subset.neq W $
  $H approx {"XX"} union.dot {"XY"}$
]

#pagebreak()
// pagename=Submission
#Submission("")
#pagebreak()
// pagename=Submission child_slavery
#Submission("child_slavery")
#pagebreak()
// pagename=Submission sexual_slavery
#Submission("sexual_slavery")

#pagebreak()
// pagename=Brainwashing
#Brainwashing("")
#pagebreak()
// pagename=Brainwashing children
#Brainwashing("children")

#pagebreak()
// pagename=Chain of Abuse
#title($"Chain of" AA"buse"$, 25pt)
#text(size: 15pt)[
  \
  $
    ... ==>_(Delta T) I_N^(bb(a)"buser") -->_(bb(a)"buse") I_(N+1)^("victim") ==>_(Delta T) I_(N+1)^(bb(a)"buser") -->_(bb(a)"buse") ...
  $
  \
  $ "All" bb(a)"busers in a chain were" bold("victims first") $
]

#pagebreak()
// pagename=Slavery
#Slavery("")
#pagebreak()
// pagename=Slavery child_slavery
#Slavery("child_slavery")
#pagebreak()
// pagename=Slavery sexual_slavery
#Slavery("sexual_slavery")

#pagebreak()
// pagename=Sexual-Consent
#Sexual-Consent("")
#pagebreak()
// pagename=Sexual-Consent guardian
#Sexual-Consent("guardian")
#pagebreak()
// pagename=Sexual-Consent rape
#Sexual-Consent("rape")

#pagebreak()
// pagename=Mass-Rape false
#Mass-Rape(false)
#pagebreak()
// pagename=Mass-Rape true
#Mass-Rape(true)

#pagebreak()
// pagename=Erasure of XX
#title("Erasure of XX", 25pt)
\
$ #female_visible arrow.r.long #female_partially_visible arrow.r.long #female_invisible $
\
#text(size: 14pt)[*$NN$egative Cycle*:]
\
#text(size: 14pt)[$... =>$ XX less visible $=>$ XY more aggressive $=>$ XX less visible $=> ...$]

#pagebreak()
// pagename=Act Now
#Act-Now("")
#pagebreak()
// pagename=Act Now urgent
#Act-Now("urgent")

#pagebreak()
// pagename=To Be Human Is To Err
#To-Be-Human-Is-To-Err("")
#pagebreak()
// pagename=To Be Human Is To Err deceived
#To-Be-Human-Is-To-Err("deceived")

#pagebreak()
// pagename=Doublespeak
#title($DD"oublespeak"$, 25pt)
\ \
$EE$vil hides behind the opposite
\ \
#text(size: 14pt)[
  #table(
    columns: (auto, auto, auto),
    row-gutter: 10pt,
    align: (horizon + center, center, horizon + center),
    stroke: none,
    [$SS$ubmission (#math.attach($SS$, bl: "i") $L_a M$, إِسْلَام)],
    [hides behind],
    [#text(fill: green.darken(30%))[Peace ($S_a L_a M$, سَلَام)]],

    [$FF$ascism], [hides behind], [#text(fill: red)[AntiFa(scism)]],
  )
]
\
Allowing civilian violence is $bb(e)$vil

#pagebreak()
// pagename=Bowing false, false
#title("Bowing", 25pt)
\
#bowers(false, false)

#pagebreak()
// pagename=Bowing true, true
#title("Bowing", 25pt)
\
#bowers(true, true)

#pagebreak()
// pagename=Muslim
#Muslim("")
#pagebreak()
// pagename=Muslim M
#Muslim("M")

#pagebreak()
// pagename=ExMuslims
#ExMuslims("")
#pagebreak()
// pagename=ExMuslims fraction
#ExMuslims("fraction")

#pagebreak()
// pagename=Worldwide Statistics
#title("Worldwide Statistics", 25pt)
\
#let stats_size = 35pt
#let stats_one = text(
  size: stats_size,
  fill: black,
)[1]
#let stats_three = text(
  size: stats_size,
  fill: rgb(0, 0, 0, 0),
  stroke: 1pt + black,
)[3]
#let stats_submitted = text(
  size: stats_size,
  fill: black,
)[$SS$ubmitted]
#let stats_free = text(
  size: stats_size,
  fill: rgb(0, 0, 0, 0),
  stroke: 1pt + black,
)[Free]
#table(
  columns: (auto, auto, auto, auto),
  align: (center, horizon + center, center, horizon + center),
  stroke: none,
  column-gutter: (30pt, 10pt, 10pt),
  table.cell(rowspan: 2, align: center + horizon)[#text(size: stats_size)[$approx$]],
  [#stats_one], [#text(size: stats_size)[:]], [#stats_three],
  [#stats_submitted], [#text(size: stats_size)[:]], [#stats_free],
)

#pagebreak()
// pagename=Phobia
#title($\"PP"hobia"\"$, 25pt)
#text(size: 15pt)[
  \ \
  *$GG$aslighting* is an $bb(a)$buser deceiving the victim about the existence of the $bb(a)$buse
  \ \
  #text(fill: red)[$excl.double$] *$DD$og-$WW$histles* alert $bb(e)$vil of threats #text(fill: red)[$excl.double$]
]

#pagebreak()
// pagename=Religion
#Religion("")
#pagebreak()
// pagename=Religion both
#Religion("both")

#pagebreak()
// pagename=Submission Conquest
#title($SS"ubmission Conquest"$, 25pt)
\
#figure(image("Submission map.png", height: 80%))

#pagebreak()
// pagename=Submission Conquest Humans re-educated
#title($SS"ubmission Conquest"$, 25pt)
\
#figure(
  stack(
    image("Submission map.png", height: 80%),
    place(
      top + left,
      dx: 65pt,
      dy: -65pt,
      scale(x: 200%, origin: horizon + left)[
        #text(fill: red)[$ arrow.l.long $]
      ],
    ),
    place(
      top + left,
      dx: 100pt,
      dy: -65pt,
      text(size: 10pt, fill: red)[
        No Submission!
        \
        Infrastructure destroyed
        \
        Humans re-educated
      ],
    ),
  ),
)

#pagebreak()
// pagename=Collectivism Conquest
#title(text(fill: red)[$CC$ollectivism Conquest], 25pt)
\
#figure(image("Collectivism map.png", height: 80%))

#pagebreak()
// pagename=Submission-Vs-Collectivism
#Submission-Vs-Collectivism("")
#pagebreak()
// pagename=Submission-Vs-Collectivism Submission
#Submission-Vs-Collectivism("Submission")

#pagebreak()
// pagename=Conflict
#Conflict("")
#pagebreak()
// pagename=Conflict intent
#Conflict("intent")

#pagebreak()
// pagename=Apartheid
#title($AA"partheid"$, 25pt)
#text(size: 15pt)[
  *Different laws for different people*
  \ \ \
  The rules of a country are called *laws*
]

#pagebreak()
// pagename=The Good Future
#The-Good-Future("")
#pagebreak()
// pagename=The Good Future ban
#The-Good-Future("ban")
#pagebreak()
// pagename=The Good Future center
#The-Good-Future("center")

#pagebreak()
// pagename=Sex Apartheid
#title($"Sex" AA"partheid"$, 25pt)
\
#table(
  columns: (0.6fr, 0.9fr),
  stroke: none,
  [#text(size: 13pt)[
    As intended by $SS$ubmission
  ]],
  figure(image("Sex Apartheid.png", height: 80%)),
)

#pagebreak()
// pagename=ExMuslim Apartheid
#ExMuslim-Apartheid("")
#pagebreak()
// pagename=ExMuslim Apartheid void
#ExMuslim-Apartheid("void")

#pagebreak()
// pagename=Religious Apartheid
#title($"Religious" AA"partheid"$, 25pt)
\
#table(
  columns: (0.6fr, 0.9fr),
  stroke: none,
  [#text(size: 13pt)[
    As intended by $SS$ubmission
  ]],
  figure(image("Religious Apartheid.png", height: 80%)),
)

#pagebreak()
// pagename=Sexual Apartheid
#title($"Sexual" AA"partheid"$, 25pt)
\
#table(
  columns: (0.6fr, 0.9fr),
  stroke: none,
  [#text(size: 13pt)[
    As intended by $SS$ubmission
  ]],
  figure(image("Sexual Apartheid.png", height: 80%)),
)

#pagebreak()
// pagename=The Bad Future
#title("The Bad Future", 25pt)
\
#table(
  columns: (0.6fr, 0.9fr),
  stroke: none,
  [#text(size: 13pt)[
    As intended by $SS$ubmission
  ]],
  figure(image("Submission goal map.png", height: 80%)),
)

#pagebreak()
// pagename=Terror
#title($TT"error"$, 25pt)
\
*Violence against random civilians*
#text(size: 15pt)[
  \ \ \
  $approx bold("50000")$ $SS$ubmission based terror attacks since *2001-09-11*
  \ \ \
  $approx bold("300000000")$ $SS$ubmission based murders in $approx$ $1400$ years
]

#pagebreak()
// pagename=Mutilation
#Mutilation("")
#pagebreak()
// pagename=Mutilation self-consent
#Mutilation("self-consent")

#pagebreak()
// pagename=Intent
#title("Intent", 25pt)
#text(size: 15pt)[
  \
  *Desired Future State*
  \ \ \
  Defines *deceit* via the difference to the declared
  \
  Desired Future State
  \ \ \
]

#pagebreak()
// pagename=Free Speech
#Free-Speech("")
// pagename=Free Speech max
#pagebreak()
#Free-Speech("max")

#pagebreak()
// pagename=Armed Forces
#Armed-Forces("")
#pagebreak()
// pagename=Armed Forces protect
#Armed-Forces("protect")
#pagebreak()
// pagename=Armed Forces arrest
#Armed-Forces("arrest")

#pagebreak()
// pagename=Social Peace
#Social-Peace("")
#pagebreak()
// pagename=Social Peace unprecedented
#Social-Peace("unprecedented")

#pagebreak()
// pagename=How to Recognize evil
#How-to-Recognize-evil("")
#pagebreak()
// pagename=How to Recognize evil censors
#How-to-Recognize-evil("censors")

#pagebreak()
// pagename=Name the Problem
#Name-the-Problem("")
#pagebreak()
// pagename=Name the Problem Submission
#Name-the-Problem("Submission")

#pagebreak()
// pagename=Financing
#Financing("")
#pagebreak()
// pagename=Financing convo
#Financing("convo")

#pagebreak()
// pagename=Submission Full
#title($SS"ubmission"$, 25pt)
\
#text(size: 14pt)[
  #table(
    columns: 4,
    column-gutter: (10%, 0%),
    // stroke: 1pt + black,
    stroke: none,
    [Easy to Enter],
    [$ "Cost-of-Entry" approx 0 $],
    table.cell(
      rowspan: 4,
      align: horizon,
      rotate(0deg, reflow: true)[
        #text(size: 25pt)[}]//#text(size: 10pt)[all Death Cults]
      ],
    ),
    table.cell(
      rowspan: 4,
      align: horizon,
      rotate(0deg, reflow: true)[
        #text(size: 11pt)[all $DD$eath Cults]
      ],
    ),
    [$TT$errible to Exit], [$ "Cost-of-Exit" = "Life" $],
    [Made to $DD$eceive], [$ "No-Exit must be secret" $],
    [Child $SS$lavery], [$ I in SS => #strong("progeny") (I) subset SS $],
    [Sexual $SS$lavery], [$ "No" #strong("sexual consent") "for XX" $], [], [],
    [Intent to Conquer], [$ "Stated goal": I in H => I in SS $],
  )
]

#pagebreak()
// pagename=Schools Of Knowledge
#Schools-Of-Knowledge("")
#pagebreak()
// pagename=Schools Of Knowledge science
#Schools-Of-Knowledge("science")
#pagebreak()
// pagename=Schools Of Knowledge math
#Schools-Of-Knowledge("math")

#pagebreak()
// pagename=Highscores Are Isotone
#Highscores-Are-Isotone("")
#pagebreak()
// pagename=Highscores Are Isotone theory
#Highscores-Are-Isotone("theory")

#pagebreak()
// pagename=Natural Advantage for the Good
#Natural-Advantage-for-the-Good("")
#pagebreak()
// pagename=Natural Advantage for the Good advantage
#Natural-Advantage-for-the-Good("advantage")

#pagebreak()
// pagename=Best Individual Ever
#Best-Individual-Ever("")
#pagebreak()
// pagename=Best Individual Ever declare
#Best-Individual-Ever("declare")
#pagebreak()
// pagename=Best Individual Ever current_best
#Best-Individual-Ever("current_best")

#pagebreak()
// pagename=fin
#fin("")
#pagebreak()
// pagename=fin share
#fin("share")
