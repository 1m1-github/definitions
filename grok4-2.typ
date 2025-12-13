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

// functions

#title("Why All the Social Unrest?", 25pt)
$ #text(size: 20pt)[$sqrt(bb(E)"vil")$] $
#place(bottom + left)[$0 < Delta bold("T")"ime"$]

#pagebreak()

#title($"Information" bold(i)$, 25pt)
\
$ "Something exists" <=> exists thick bold("1") $
$ "Something else also exists" <=> exists thin i : i != 1 => exists thick bold("0") $
New information via *Union*
$ 1 union 0 arrow.r.long 10 $
$ 10 union 0 arrow.r.long 100 $
$ dots.v $
*Everything* is information and all information *wants* to exist

#pagebreak()

#title("Learning", 25pt)
\
#text(size: 15pt)[
  $ bold("The Ability to Change") $
  $ bold("Follows Feedback") $
]
#text(size: 12pt)[
  $"Your Best" bold("Ability")$
]

#pagebreak()

#title("Reliability", 25pt)
\
#text(size: 14pt)[
  $ i_(bold("Input")) arrow.r.long_(i_(bold("Next"))) i_(bold("Output")) $
  $ bold("Error") = || i_(bold("Knowledge")) - i_("Next") || $
  $ bold("Reliability") = "Error"^(-1) $
]
#text(size: 12pt)[
  $"Studied in" bold("Statistics")$
]

#pagebreak()

#title("Complexity", 25pt)
\ \
#text(size: 14pt)[
  All information can be represented as a *boolean circuit*
  $ bold("Complexity")(i) = min_("circuit"=i) \#"gates" $
  $ "Complexity"(i) <= "Complexity"(i union i') $
  $ bold("Purpose")": Complexity"(W_T) < "Complexity"(W_(T + Delta T)) $
]

#pagebreak()

#title($"Individuals" bold(I)$, 25pt)
\
#social-structure(rng, colors, 10, 8, empty-fill-shape, circle_radius, 50%, 100%)
\
#box[
  #circle(radius: circle_radius)
] #text(size: 14pt)[Inputs, outputs and keeps private information *allowing deception*]

#pagebreak()

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

#title("World", 25pt)
\
#text(size: 15pt)[
  $ exists thin i => i in W $
  $ W = {S_1,...,S,...,S_N,I_1,...,I_N,...} $
  $ W-S = {S_1,...,S_2,I_1,...,I_N,...} "is" W bold("without") S , thick "same" I $
]

#pagebreak()

#title("Why All the Social Unrest?", 25pt)
$ #text(size: 20pt)[$sqrt(bb(E)"vil")$] $
#place(bottom + left)[$0 < Delta bold("T")"ime"$]

#pagebreak()

#title("Health", 25pt)
\
#text(size: 14pt)[
  $ bold("Lifespan")(i) = Delta"T such that" i in W $
  $ bold("Health") = bb(E)["Lifespan"] $
  $ S "is" bold("good") <=> 0 < bold(Delta)"Health"(W-S) = "Health"(W) - "Health"(W-S) $
  $ S "is" #strong($bb(b)"ad"$) <=> Delta"Health"(W-S) < 0 $
]

#pagebreak()

#title($EE"vil"$, 25pt)
\
#text(size: 13pt)[
  $ S "is" bold(bb(e)"vil") <=> S "is" bold("provably") bb(b)"ad" $
  $ S "is" bold(EE"vil") <=> Delta"Health"(W-S) = min_(bb(e)"vil" S') Delta"Health"(W-S') $
]
#text(size: 15pt)[
  An $bb(e)$vil social structure is a *social $bb(v)$irus* inside the individual
]

#pagebreak()

#title($ "Cost-of-Entry"(S) $, 25pt)
#text(size: 15pt)[$ I in S => I "knows Cost-of-Entry"(S) $]
#text(size: 13pt)[$ => S "cannot hide Cost-of-Entry"(S) "from" I $ ]

#pagebreak()

#title($bold("Cult")(S) = "Cost-of-Exit"(S)$, 25pt)
\ \
#cetz.canvas(
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
    content((2, -2 * a), anchor: "north", "life")
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
#table(
  columns: (0.9fr, 0.9fr, 0.9fr),
  align: (horizon + center, center, horizon + center),
  [Cult(S)], [Cult(S) Secrecy], [\#Enforcers$div$\#Individuals],
  [$arrow.t$], [$arrow.t$], [$arrow.b$],
  [$arrow.b$], [$arrow.b$], [$arrow.t$],
)

#pagebreak()

#title($DD"eath Cult"$, 25pt)
\
$S "is a" #strong($DD"eath Cult"$) <=> "Cult"(S) = "Life" <=> bold("No-Exit")$
\ \
$=> S "is a" DD"eath Cult" => "No-Exit has to be fully" bold("secret")$
\ \
$=> I in S_(DD"eath Cult") "is" bold("forced") "to" bb(d)"eceive"$
\ \
$=> "All statements by" I in S_(DD"eath Cult") "about" S_("Death Cult") "are under" #strong($bb(d)"uress"$)$
\
$ S_("Death Cult") "intends to be an informational" bold("black hole") "pretending differently" $

#pagebreak()

#title($CC"ensorship Hides "bb(e)"vil"$, 25pt)
\ \
#text(size: 15pt)[
  To stop *consenting* entities from exchanging information
  $ i in CC "and" bb(e) "is" bb(e)"vil" $
  $ => bb(e) "can convince the Enforcers that" i = \"bb(e) "is" bb(e)"vil"\" $
]

#pagebreak()

#title($CC"ensorship Reduces Health"$, 25pt)
\ \
$ 0 < Delta_T"Health"(W) => 0 < Delta_T"Complexity"(W) $
\
#table(
  columns: (0.9fr, 0.6fr, 0.6fr),
  align: (horizon + center, center, horizon + center),
  [$CC$ensorship], [Complexity], [Health],
  [$arrow.t$], [$arrow.b$], [$arrow.b$],
  [$arrow.b$], [$arrow.t$], [$arrow.t$],
)

#pagebreak()

#title($DD"eath Cults Are" bb(e)"vil"$, 25pt)
\
#text(size: 15pt)[
  Full secrecy of No-Exit needs #strong($CC$)ensorship
  \ \
  $DD$eath Cults deny their members *Freedom*
  \ \
  #strong($EE"vil"$) is the largest $DD$eath Cult of the World
]

#pagebreak()

#title($EE"vil"$, 25pt)
\
#text(size: 13pt)[
  $ S "is" bold(bb(e)"vil") <=> S "is" bold("provably") bb(b)"ad" $
  $ S "is" bold(EE"vil") <=> Delta"Health"(W-S) = min_(bb(e)"vil" S') Delta"Health"(W-S') $
]
#text(size: 15pt)[
  An $bb(e)$vil social structure is a *social $bb(v)$irus* inside the individual
]

#pagebreak()

#title("Solution", 25pt)
\
#text(size: 13pt)[
  $ S "is" thick DD"eath Cult" => "No-Exit is secret" $
  $ <=> "No-Exit is" #strong("not") "secret" => S "cannot be a" DD"eath Cult" $
]
#text(size: 15pt)[
  #box(stroke: 2pt + black, height: 10%, width: 60%)[$ "Reveal No-Exit" => "no" DD"eath Cult" $]
  \
  Members of a $DD$eath Cult *need saving* from non-members
  \ \
  WARNING ...
]

#pagebreak()

#title($DD"eath of a" DD"eath Cult"$, 25pt)
\
#text(size: 15pt)[
  The $DD$eath Cult will *flight* xor *fight* xor *$bb(d)$ie*
  $ S in I bb(d)"ies" => I in.not S bold("and") I in W $
  $ forall I in W: I in.not S => S in.not W $
]

#pagebreak()

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

#title("Humanity", 25pt)
\ \
#text(size: 15pt)[
  $ "Humanity" H = {S_1,...,S_N,I_1,...,I_N,...} subset.neq W $
  $H approx {"XX"} union.dot {"XY"}$
]

#pagebreak()

#title($EE"vil" = SS"ubmission"$, 25pt)
\
#text(size: 15pt)[
  $ I in SS => #strong("progeny") (I) subset SS $
  $ "No" #strong("sexual consent") "for XX" $
]

#pagebreak()

#title("Brainwashing", 25pt)
\
#text(size: 13pt)[
  Children *trust* guardians
  \ \
  $H$ could require all $I$ to view some specific information $i_("chosen")$ regularly
  \
  $i_("chosen")$ begotten via voting or from a random individual and short
]

#pagebreak()

#title($"Chain of" AA"buse"$, 25pt)
\
$
  ... => I_N^(bb(a)"buser") -->_(bb(a)"buse") I_(N+1)^("victim") ==>_(Delta T) I_(N+1)^(bb(a)"buser") -->_(bb(a)"buse") ...
$
$ "All" bb(a)"busers in a chain were" bold("victims first") $
$ "All" bold("born") "into" SS"ubmission are" bold("victims") "in childhood" $

#pagebreak()

#title($SS"lavery"$, 25pt)
#text(size: 15pt)[
  \
  $I$ do not own my own consent
  \
  $<=> I$ cannot freely choose my $S$ membership
  \ \
]
#text(size: 25pt)[
  *Sexual $SS$lavery*
]
#text(size: 15pt)[
  \ \
  $I$ do not own my own sexual consent
  \
  $<=> I$ cannot freely choose my sex partner
]

#pagebreak()

#title($EE"vil" = SS"ubmission"$, 25pt)
\
#text(size: 15pt)[
  $ I in SS => #strong("progeny") (I) subset SS $
  $ "No" #strong("sexual consent") "for XX" $
]

#pagebreak()

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
#title("Sexual Consent", 25pt)
\
*Voluntary agreement to sex*
\ \
$ forall I_"XX" in H thick thick exists thick I_"XY" = bold("\"guardian\"") in SS"ubmission": $
$ bold("owner")("sexual consent"(I_"XX")) = I_("XY") != I_"XX" $
$ => I "cannot consent to sex" => I "did not consent to sex" $
$ => forall I in SS"ubmission": "sex"=bb(r)"ape" $

#pagebreak()

#title($"Mass" RR"ape"$, 25pt)
\
#text(size: 15pt)[
  *"marriage"* under $SS$ubmission
  $ <=> I_"XX" != "\"guardian\""_T (I_"XX") != "\"guardian\""_(T + Delta T) (I_"XX") != I_"XX" $
  \
  $approx$ #strong($10^8$) $SS$ubmitted XX are $bold(bb(r))$*aped daily* in silence
]

#pagebreak()

#title("Erasure of XX", 25pt)
\
$ #female_visible arrow.r.long #female_partially_visible arrow.r.long #female_invisible $
\
#text(size: 14pt)[*$NN$egative Cycle*:]
\
#text(size: 14pt)[$... =>$ XX less visible $=>$ XY more aggressive $=>$ XX less visible $=> ...$]

#pagebreak()

#title("Act Now", 25pt)
\
#text(size: 15pt)[
  $ \#SS"ubmission" approx underbracket(O(3^T) >> O(2^T), Delta="sexual consent") approx \#"World" $
  \
  The *cost* of destroying $SS$ubmission *increases* over time
]

#pagebreak()

#title("To Be Human Is To Err", 25pt)
\
#text(size: 15pt)[
  You are *not* God
  \ \
  You *could* be wrong and *deceived*
  \ \
  Take a *meta* step back to check
]

#pagebreak()

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

#title("Bowing", 25pt)
\
#bowers(false, false)

#pagebreak()

#title("Bowing", 25pt)
\
#bowers(true, true)

#pagebreak()

#let slm = $attach(SS, bl: "u")"L"_i"M"$
#let slm2 = math.underbracket(slm, text(size: 12pt)[$SS$ubmission])
#let muslim = $underbracket(MM, #text(size: 12pt)[$MM$ohammed]) thin #slm2$
#title(muslim, 25pt)
\ \ \
An individual that *$SS$ubmits* to $MM$
\
All *criticism* of $MM$ is punishable by $bb(d)$*eath*
\
All $SS$ubmitted are *supposed* to follow the *example* of $MM$
\
$MM$ ordered the *$bb(g)$enocide* of the people of the XX that *$bb(p)$oisoned* him to $bb(d)$eath
\
$MM$ allowed *sex $bb(s)$lavery* and $bold(bb(r))$*aped* a *minor* (< 10 years old) at nearly 10x her age
\ \
$MM$ even hated and genocided *dogs*

#pagebreak()

#title($"Mass" RR"ape"$, 25pt)
\
#text(size: 15pt)[
  *"marriage"* under $SS$ubmission
  $ <=> I_"XX" != "\"guardian\""_T (I_"XX") != "\"guardian\""_(T + Delta T) (I_"XX") != I_"XX" $
  \
  $approx$ #strong($10^8$) $SS$ubmitted XX are $bold(bb(r))$*aped daily* in silence
]

#pagebreak()

#title($MM attach(SS, bl: "u")"L"_i"Ms" "Are Forced To Be" MM attach(SS, bl: "u")"L"_i"M"$, 21pt)
\ \
#text(size: 14pt)[
  Born $MM attach(SS, bl: "u")"L"_i"Ms"$ *never* get to consent
  \
  $MM attach(SS, bl: "u")"L"_i"Ms"$ deserve a choice
  \
  *Ex*$#strong($MM attach(SS, bl: "u")"L"_i"Ms"$)$ are aware of being trapped in a $DD$eath Cult
  \
  $ (\#"Ex"MM attach(SS, bl: "u")"L"_i"Ms")/(\# MM attach(SS, bl: "u")"L"_i"Ms") approx 1/4 $
]

#pagebreak()

#title($"Ex"MM attach(SS, bl: "u")"L"_i"Ms Are Illegal"$, 20pt)
#image("ExMuslim Illegal.png", width: 50%)
Void these laws to start a Tsunami of Freedom

#pagebreak()

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

#title($\"PP"hobia"\"$, 25pt)
#text(size: 15pt)[
  \ \
  *$GG$aslighting* is an $bb(a)$buser deceiving the victim about the existence of the $bb(a)$buse
  \ \
  #text(fill: red)[$excl.double$] *$DD$og-$WW$histles* alert $bb(e)$vil of threats #text(fill: red)[$excl.double$]
]

#pagebreak()

#title("Religion", 25pt)
\ \
#text(size: 15pt)[
  Teachings about God
  \ \
  $bb(S)$ubmission can be a religion *and* the largest $DD$eath Cult
]

#pagebreak()

#title($SS"ubmission"$, 25pt)
\
#figure(image("Submission map.png", height: 80%))

#pagebreak()

#title(text(fill: red)[$CC$ollectivism], 25pt)
\
#figure(image("Collectivism map.png", height: 80%))

#pagebreak()

#title($bb(S)"ubmission vs" #text(fill: red)[$CC$ollectivism]$, 25pt)
\
#text(fill: red)[*$CC$ollectivism*] is using $SS$ubmission to *destroy* the free world
\ \
and, more precisely,
\ \
$SS$ubmission is using #text(fill: red)[$CC$ollectivism] to *destroy* the free world
\
because $SS$ubmission is much $bb(d)$eadlier and bigger
\ \
#text(fill: red)[$CC$ollectivism] = {$CC$ommunism, $SS$ocialism, ...}

#pagebreak()

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

#title("Conflict", 25pt)
\
$ arrow.r = #strong($bb(g)"enocide"$) = "the" bold("intent") "to destroy all individuals in a social structure" $
$ S_(bb(a)"buser and victim") arrows.lr tilde(S)_(bb(a)"buser and victim") $
$ approx $
$ S_(bb(d)"eceptive" bb(a)"buser") arrow.r S_("victim") $
\
*intent* matters
\

#pagebreak()

#title($AA"partheid"$, 25pt)
#text(size: 15pt)[
  *Different laws for different people*
  \ \ \
  The rules of a country are called *laws*
]

#pagebreak()

#title("The Good Future", 25pt)
\
#table(
  columns: (0.6fr, 0.9fr),
  stroke: none,
  [
    #text(size: 13pt)[
      *Ban* $SS$ubmission and *send* the adamant to be together
      \ \
    ] #text(size: 10pt)[
      Only $SS$ubmission *created current* country
      \
      Only $SS$ubmission *ruled nuclear* country
      \
      $=>$ Modern *center* of $SS$ubmission
    ]],
  figure(image("Countries Created for Submission map.png", height: 80%)),
)

#pagebreak()

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

#title($MM"utilation"$, 25pt)
\
*Permanent abnormal change*
#text(size: 15pt)[
  \ \ \
  Requires *self-consent* and only adults can consent
  \ \
  $approx bold("60000")$ $SS$ubmission based $bb(m)$utilations *daily*
]

#pagebreak()

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

#title("Free Speech", 25pt)
\
*Maximizes* information flow, *purges* $bb(e)$vil and is costly to *protect*
\ \
*Violence* is intentional, physical harm
\ \
*Not* convincing people does *not* justify violence
\ \
The *punishment* for deception should be proportional to the *damage*

#pagebreak()

#title("Armed Forces", 25pt)
\ \
#text(size: 14pt)[
  The entity with the purpose of *protecting free speech*
  \ \
  1 Armed Forces / *country*
  $ I in.not "Armed Forces" => I in bold("Civilians") $
  Always *arrest* the $bb(a)$buser, else $bb(e)$vil can use groups
  \ \
  For real power, *join* the Armed Forces
]

#pagebreak()

#title("Social Peace", 25pt)
\
#text(size: 15pt)[
  $ Delta"Health"(W-SS) = min_(S in W) Delta"Health"(W-S) $
  Removing $SS$ubmission from the world would result in *unprecedented social peace*
  \ \
  We *could* only have to contend with *non-human threats*
  \
  which are substantial and plenty
]

#pagebreak()

#title($"How to Recognize" bb(e)"vil"$, 25pt)
\ \
#text(size: 15pt)[
  Whoever *censors* you or suggests *violence* is $bb(e)$vil
  \ \ \
]
#text(size: 13pt)[
  unless you are part of non-$bb(e)$vil Armed Forces and a superior commands it
]

#pagebreak()

#title("Name the Problem", 25pt)
\
#figure(image("Submission symbol.png", width: 5%))
#text(size: 15pt)[$SS$ubmission = #math.attach($SS$, bl: "i") $L_a M$]
\ \ \
Rather than the agents of $SS$ubmission that are *currently* most problematic

#pagebreak()

#title("Financing", 25pt)
\ \
#text(size: 15pt)[
  *Protection $RR$acket*
]
\ \
#table(
  columns: 3,
  row-gutter: 5%,
  stroke: none,
  align: (right, center, left),
  [$SS$ubmission], [:], ["Pay me to protect you."],
  [You], [:], ["To protect from whom?"],
  [$SS$ubmission], [:], ["From me!"],
)

#pagebreak()

#title("Free Speech", 25pt)
\
*Maximizes* information flow, *purges* $bb(e)$vil and is costly to *protect*
\ \
*Violence* is intentional, physical harm
\ \
*Not* convincing people does *not* justify violence
\ \
The *punishment* for deception should be proportional to the *damage*

#pagebreak()

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
    [Terrible to Exit], [$ "Cost-of-Exit" = "Life" $],
    [Made to $DD$eceive], [$ "No-Exit must be secret" $],
    [Child $SS$lavery], [$ I in SS => #strong("progeny") (I) subset SS $],
    [Sexual $SS$lavery], [$ "No" #strong("sexual consent") "for XX" $], [], [],
    [Intent to Conquer], [$ "Stated goal": I in H => I in SS $],
  )
]

#pagebreak()

#title("Natural Advantage for the Good", 25pt)
\ \
#table(
  columns: (0.9fr, 0.6fr, 0.6fr),
  align: (horizon + center, center, horizon + center),
  [\#$SS$ubmission$div$\#Individuals], [Complexity], [Health and Wealth],
  [$arrow.t$], [$arrow.b$], [$arrow.b$],
  [$arrow.b$], [$arrow.t$], [$arrow.t$],
)

#pagebreak()

#title("Best Human Ever", 25pt)
\ \
#text(size: 15pt)[
  Humanity should ask all to *publicly* declare a choice
  \ \
  This *discerns* and *unifies* at the same time
  \ \
  Human with the highest votes: *Jesus* of Nazareth
]

#pagebreak()

This is the most censored and important information for our World
\ \
*You need to share*
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
]

#pagebreak()

#title("Schools Of Knowledge", 25pt)
\
$ "Competition" = "Optimization" => "Maximizes World Complexity" $
\
#text(size: 14pt)[
*Best* is based on Reliability and Learning called *Science*
\ \
*Mathematics* is the *study* of *information*
\
and the most *precise language* for the interpretation of information
]

#pagebreak()

#title("Highscores Are Isotone", 25pt)
\
$ "Most reliable current knowledge is called" bold("Theory") $
$ "An idea to increase reliability is called a" bold("Hypothesis") $
$ 0 < Delta_T"reliability"(W) => 0 < Delta_T"complexity"(W) $
$ "reliability"("Theory"_T) <= "reliability"("Theory"_(T + Delta T)) $

#pagebreak()

#title("Natural Advantage for the Good", 25pt)
\ \
#table(
  columns: (0.9fr, 0.6fr, 0.6fr),
  align: (horizon + center, center, horizon + center),
  [\#$SS$ubmission$div$\#Individuals], [Complexity], [Health and Wealth],
  [$arrow.t$], [$arrow.b$], [$arrow.b$],
  [$arrow.b$], [$arrow.t$], [$arrow.t$],
)

#pagebreak()

#title("Natural Advantage for the Good", 25pt)
\ \
#table(
  columns: (0.9fr, 0.6fr, 0.6fr),
  align: (horizon + center, center, horizon + center),
  [\#$SS$ubmission$div$\#Individuals], [Complexity], [Health and Wealth],
  [$arrow.t$], [$arrow.b$], [$arrow.b$],
  [$arrow.b$], [$arrow.t$], [$arrow.t$],
)

#pagebreak()

#title($EE"vil" = SS"ubmission"$, 25pt)
\
#text(size: 15pt)[
  $ I in SS => #strong("progeny") (I) subset SS $
  $ "No" #strong("sexual consent") "for XX" $
]

#pagebreak()

#title($"Mass" RR"ape"$, 25pt)
\
#text(size: 15pt)[
  *"marriage"* under $SS$ubmission
  $ <=> I_"XX" != "\"guardian\""_T (I_"XX") != "\"guardian\""_(T + Delta T) (I_"XX") != I_"XX" $
  \
  $approx$ #strong($10^8$) $SS$ubmitted XX are $bold(bb(r))$*aped daily* in silence
]

#pagebreak()

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

#title("Free Speech", 25pt)
\
*Maximizes* information flow, *purges* $bb(e)$vil and is costly to *protect*
\ \
*Violence* is intentional, physical harm
\ \
*Not* convincing people does *not* justify violence
\ \
The *punishment* for deception should be proportional to the *damage*

#pagebreak()

#title("Social Peace", 25pt)
\
#text(size: 15pt)[
  $ Delta"Health"(W-SS) = min_(S in W) Delta"Health"(W-S) $
  Removing $SS$ubmission from the world would result in *unprecedented social peace*
  \ \
  We *could* only have to contend with *non-human threats*
  \
  which are substantial and plenty
]

#pagebreak()

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

#title("Act Now", 25pt)
\
#text(size: 15pt)[
  $ \#SS"ubmission" approx underbracket(O(3^T) >> O(2^T), Delta="sexual consent") approx \#"World" $
  \
  The *cost* of destroying $SS$ubmission *increases* over time
]

#pagebreak()

#title("Solution", 25pt)
\
#text(size: 13pt)[
  $ S "is" thick DD"eath Cult" => "No-Exit is secret" $
  $ <=> "No-Exit is" #strong("not") "secret" => S "cannot be a" DD"eath Cult" $
]
#text(size: 15pt)[
  #box(stroke: 2pt + black, height: 10%, width: 60%)[$ "Reveal No-Exit" => "no" DD"eath Cult" $]
  \
  Members of a $DD$eath Cult *need saving* from non-members
  \ \
  WARNING ...
]

#pagebreak()

#title("The Good Future", 25pt)
\
#table(
  columns: (0.6fr, 0.9fr),
  stroke: none,
  [
    #text(size: 13pt)[
      *Ban* $SS$ubmission and *send* the adamant to be together
      \ \
    ] #text(size: 10pt)[
      Only $SS$ubmission *created current* country
      \
      Only $SS$ubmission *ruled nuclear* country
      \
      $=>$ Modern *center* of $SS$ubmission
    ]],
  figure(image("Countries Created for Submission map.png", height: 80%)),
)

#pagebreak()

#title("Natural Advantage for the Good", 25pt)
\ \
#table(
  columns: (0.9fr, 0.6fr, 0.6fr),
  align: (horizon + center, center, horizon + center),
  [\#$SS$ubmission$div$\#Individuals], [Complexity], [Health and Wealth],
  [$arrow.t$], [$arrow.b$], [$arrow.b$],
  [$arrow.b$], [$arrow.t$], [$arrow.t$],
)

#pagebreak()

#title("Best Human Ever", 25pt)
\ \
#text(size: 15pt)[
  Humanity should ask all to *publicly* declare a choice
  \ \
  This *discerns* and *unifies* at the same time
  \ \
  Human with the highest votes: *Jesus* of Nazareth
]

#pagebreak()

This is the most censored and important information for our World
\ \
*You need to share*
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
]

#pagebreak()