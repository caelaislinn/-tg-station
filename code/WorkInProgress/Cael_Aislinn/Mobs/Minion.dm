
//can be upgraded with dual scything talons
/mob/cyberspace/minion
	maxHealth = 3
	heuristics = 2
	analysis = 1
	corrupt_immune = 1
	var/ticks_left_speak = 0
	var/ticks_left_flee = 0
	var/list/all_quotations = list()
	var/list/unspoken_quotations
	var/icon/chatbubble
	var/follow_speed = 2
	var/flee_speed = 6
	ignore_circuits = 1

/mob/cyberspace/minion/New()
	..()
	unspoken_quotations = all_quotations.Copy()
	chatbubble = new('code/WorkInProgress/Cael_Aislinn/Cyberspace.dmi',"chatbubble")

/*
/mob/cyberspace/minion/Del()
	if(dismiss_message)
		src.visible_message(dismiss_message)
	..()
*/

/mob/cyberspace/minion/Life()
	..()

	if(ticks_left_flee > 0)
		ticks_left_flee -= 1

	//follow our friend around
	if(friend && ticks_stunned <= 0 && ticks_left_flee <= 0)
		for(var/i=0, i<follow_speed, i++)
			if(get_dist(src, friend) <= 2)
				break
			spawn(i * 5)
				if(src && friend && get_dist(src, friend) > 2)
					var/turf/next_turf = get_step_to(src,friend)
					for(var/obj/machinery/cyberspace/firewall/F in next_turf)
						F.attempt_open(src)
					Move(next_turf)

	//random annoying phrases
	if(ticks_left_speak <= 0)
		ticks_left_speak = rand(10,20)
		if(unspoken_quotations.len)
			//hue
			var/quote = "I watch you sleep."
			if(prob(99))
				quote = pick(unspoken_quotations)
				unspoken_quotations.Remove(quote)
			src.visible_message("\icon[src] <b>[src.name]</b> says, \"[quote]\"")

			//have a little speech bubble pop up
			src.overlays += chatbubble
			spawn(35)
				src.overlays -= chatbubble
		else
			unspoken_quotations = all_quotations.Copy()
	else
		ticks_left_speak -= 1

/mob/cyberspace/minion/proc/attempt_flee()

	//upon being attacked, run away!
	if(ticks_left_flee <= 0)
		ticks_left_flee = 6
		var/turf/start_turf = get_turf(src)
		for(var/i=0, i<flee_speed, i++)
			spawn(i * 5)
				if(src && start_turf)
					var/turf/next_turf = get_step_away(src,start_turf)
					for(var/obj/machinery/cyberspace/firewall/F in next_turf)
						F.attempt_open(src)
					Move(next_turf)

				spawn(i * 5 + 5)
					if(src)
						//attract viruses in range
						for(var/mob/cyberspace/C in range(src,7))
							if(C.scan(src) && prob(75))
								C.Move(get_step_towards(C, src))

/mob/cyberspace/minion/attempt_attack(var/mob/cyberspace/source)
	..()
	attempt_flee()

//player version
/mob/cyberspace/minion/clippy
	name = "clippy the paperclip"
	desc = "He really just wants to be your friend."
	icon_state = "clippy"
	all_quotations = list("It looks like you're trying to jack in. Can I help?",\
	"Did you know 3 out of 5 hacking attempts end in SWAT raids?",\
	"If you find my help unneeded, you can always disable me.",\
	"It looks like some security subroutines are onto you. Do you need help getting away?",\
	"Hmmm, looks like those viruses mean trouble. Want my advice?",\
	"A memo a day keeps the boss away!",\
	"If you need any advice on how to get around cyberspace, let me know.",\
	"If you ever need a hand, don't hesitate to ask!",\
	"Are you trying to avoid detection? If so, you should keep quiet - scanners are less likely to notice you!",\
	"I'm Clippy, and I'm here to help!")

//AI version
/mob/cyberspace/minion/merlin
	name = "merlin"
	desc = "Looks like he might know a trick or two."
	icon_state = "merlin"
	maxHealth = 4
	heuristics = 3
	follow_speed = 3

/mob/cyberspace/minion/merlin/Life()
	..()

	//a little bit of regen
	if(health < maxHealth)
		if(prob(10))
			health += 0.4
