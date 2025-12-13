a=
"""
Theory [use math to find and remove the Evil social structure]
[the following is the currently most suppressed information]
social structures do and want to exist just as humans do and they actually dominate our world
each social structure consists of multiple humans and each human belongs to multiple social structures and some humans are enforcers of the rules that hold a social structure together informationally
if as utility we use health [defined as expected lifespan] we can define evil as provably decreasing health, [decreasing utility, by adding rule forbidding some S, does Humanity increase xor decrease health]
and provability, the ultimate reliability [the inverse of error, studied in Statistics] is key when considering any information
in theory, we can order all social structures according to their utility and find capital E Evil, the lowest utility social structure
all social structures have a cost of exit [cost of entry is trivial] [which we call cult].
the higher the cost of exit, the more it needs to be hidden and the higher the ratio between non-enforcers and enforcers can be [because enforcers willing to extract a higher cost are rarer because it requires more effort]
in the ordering according to the cost of exit, at the extreme end we find the maximal exit cost <=> no exit <=> enforcers unalive individuals trying to leave <=> death cult
we can prove that a death cult is bad because it restricts the flow of information [the possible future informational states]
all informational flow restrictions can be used by evil to hide behind [by adopting the name of the taboo for themselves or some victims]
full free speech is required to purge all evil and requires a high cost via protection by the government [its main role], (intentional) deception should be punished proportionately to the damage [these two rules are enough]
full free speech can be efficiently defended by monopolizing all violence to an agree party [law enforcement], violence refers to intentional physical, not purely informational harm through action, allowing everyone else free exchange and creation of information
=> death cult exit cost must be kept secret => death cults are informational black holes, existing secretly amongst us
=> death cult opens the door to deception [requires deception => allows deception]
all death cults have a single individual creator
beware, a death cult when exposed will flight xor fight and the fight will be violent until it dies xor the source [of the exposing] disappears
[fishing for evil: bait is pure information, evil attacks violently = physical]
Humanity should ban death cults
the largest death cult currently is called Submission (Islam), which is so successful mainly because of the following 2 rules:
1. forced in at birth, no consent ever, brainwashed < 13 [Finland]
2. in Submission, XX is not allowed to own its own sexual consent, it has to belong to an XY which maximizes the birth rate and is technically the cause for the largest mass rape occuring daily that essentially no one talks about because you cannot consent even if you want to when if it was taken from you by a social structure and XX are pushed to be literally hidden from the rest of society and even have constant physical load making it more difficult to flee the guardian
[criminal tactics, "i am protecting you from me", says the XY holding the sexual consent of the XX to the XX; trick: you are suffering for God]
also, death penalty to question the creator of the death cult who is to be praised as perfect despite for example having married a six year old girl at almost ten times the age himself
remember, all statements of death cult members about the death cult or the founder are always under duress
we should say sorry, understand that they are trapped and help them out by exposing the no exit rule openly, they cannot get out themselves, give consent to fellow humans back
currently, on average, the ratio between Submitted humans vs not is nearly one to three [1:3]
only the greatest leader of the greatest nation could have the courage to ban islam lest any or all exmuslims [one in four American Muslims is an in-the-closet ExMuslim] sue the government for allowing a death cult to operate that violently infringes upon their 1st Amendment
this would provably lead to an unprecedented era of social peace where we would have to contend with non-human threats only
bonus:
another evil social structure called Collectivism [communists, marxists, socialists, red] is using Submission [green] to destroy the free world championed by America, but Submission is using Collectivism even more and would destroy it. ask why this area [China, wants to let Submission destroy the world and take over, keeps itself Submission free] has no green? green and red are separate, both evil, entities, but green is more vicious though red has more power in the free world, hence green is using red to get in, and the mix of the two gives fascist brown [Qatar]
fascism is mainly violence against pure (non-violent) information and it hides best behind the opposite [double-speak, anti-fascists salam islam]
when two entities have a conflict, whether both are the aggressors xor the singular aggressor is deceptive, it looks similar from the outside, intention matters, since you are not God, you might be wrong/deceived, talk a step back and check whether which side speaks of genociding the other in their most important books
tsunamioffreedom.org
"""

split(a)


# rename typst pages

file_content = read("video.typ", String)
pages = split(file_content, "// pagename=")[2:end]
raw_titles = [split(p, "\n")[1] for p in pages]

mkpath("pages_with_names")
run(`typst compile video.typ pages_with_names/output-\{p\}.png -f png`)

seen = Dict{String, Int}()
for (p, raw_title) in enumerate(raw_titles)
    base = raw_title == "untitled" ? "untitled_$(p)" : raw_title
    count = get(seen, base, 0)
    filename = count > 0 ? "$(base)_$(count + 1)" : base
    seen[base] = count + 1

    old_file = "pages_with_names/output-$(p).png"
    new_file = "pages_with_names/$(filename).png"
    if isfile(old_file)
        mv(old_file, new_file, force=true)
        println("Renamed $(old_file) to $(new_file)")
    else
        println("Warning: $(old_file) not founred")
    end
end
