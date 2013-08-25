
/mob/cyberspace/agent
	name = "agent"
	desc = "A fellow sentient subroutine."
	icon_state = "agent"
	var/hide_chance = 8
	var/energy = 1000
	analysis = 1
	penetration = 1
	heuristics = 1
	redundancy = 1
	var/obj/item/cyberdeck/casting_deck
	var/obj/effect/proc_holder/cyber_ability/active_ability

	//summonable minions

	var/list/ability_list = list()

	see_in_dark = 9		//seriously fix this bug

/mob/cyberspace/agent/New()
	..()

	//setup abilities
	for(var/cur_type in typesof(/obj/effect/proc_holder/cyber_ability))
		var/obj/effect/proc_holder/cyber_ability/C = new cur_type(src)
		//world << "[C.type] | [C.name] | [C.desc]"
		if(!C.name || !C.desc)
			C.loc = null
			//world << "	skipped"
			continue
		//world << "	added"

		ability_list[cur_type] = C

	name = "[name] ([rand(1,9)][rand(0,9)][rand(0,9)][rand(0,9)])"

	//src.verbs += /mob/cyberspace/agent/proc/summon_clippy
	//src.verbs += /mob/cyberspace/agent/proc/summon_merlin

/*
/mob/cyberspace/agent/proc/initialise_abilities()
	known_abilities.Add(new /datum/cyber_ability/summon/merlin())
	known_abilities.Add(new /datum/cyber_ability/summon/clippy())
	known_abilities.Add(new /datum/cyber_ability/target/error_processor())
	known_abilities.Add(new /datum/cyber_ability/target/wipe())
*/

/mob/cyberspace/agent/Stat()
	..()

	if(ability_list.len)
		for(var/ability_type in ability_list)
			var/obj/effect/proc_holder/cyber_ability/C = ability_list[ability_type]
			if(C.stat_desc)
				statpanel("Cyberspace", "[C.stat_desc]", C)
			else if(C.cooldown_left > 0)
				statpanel("Cyberspace", "Cooldown [C.cooldown_left]s", C)
			else
				if(C.require_charges)
					statpanel("Cyberspace", "[C.charges_left] charges left", C)
				else
					statpanel("Cyberspace", "Ready", C)
