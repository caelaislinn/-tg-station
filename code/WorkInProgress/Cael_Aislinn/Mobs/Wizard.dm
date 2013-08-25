
/mob/cyberspace/wizard
	name = "wizard subroutine"
	desc = "No sense of right or wrong! Just kidding, but he's a bit of a loose cannon."
	icon_state = "wizard"
	//
	analysis = 1
	programming = 1.5
	penetration = 2
	heuristics = 2
	redundancy = 10

	maxHealth = 4
	authorised = 1
	ignore_circuits = 1

	var/obj/machinery/cyberspace/wizard_program/parent_program

	var/ticks_left_alternate = 15
	var/ticks_per_state = 15
	//state = 0:wizard, 1:warlock
	var/alternating = 1

	var/atom/target_patrol
	var/mob/cyberspace/target_mob
	var/obj/machinery/cyberspace/glitch/target_glitch
	var/turf/target_turf

/mob/cyberspace/wizard/Life()
	. = ..()

	if(ticks_stunned <= 0)
		//periodically alternate between repair and combat forms
		if(alternating)
			ticks_left_alternate -= 1
			if(ticks_left_alternate <= 0)
				ticks_left_alternate = ticks_per_state
				if(state)
					state = 0
					icon_state = "wizard"
					target_mob = null
				else
					state = 1
					icon_state = "warlock"
					target_glitch = null
				src.visible_message("<span class='info'>\icon[src] [src] puts on his [icon_state] hat.</span>")

		//work out where we're going
		var/turf/next_turf

		if(state)
			//hunting malware

			//find a target
			if(!target_mob)
				//if we're corrupted, target friendly mobs
				var/detect_range = 7
				if(corrupted)
					detect_range = 0
				target_mob = detect_enemy_mob(detect_range)

			//we have a target
			if(target_mob)
				//move towards it if we're out of range
				if(get_dist(src, target_mob) > 1)
					next_turf = get_step_to(src,target_mob)
				else
					//stand still and attack it
					if(target_mob.attempt_attack(src) == 2)
						//gain a bit of health for destroying it
						health = min(health + 0.5, maxHealth)
						target_mob = null
					next_turf = src.loc
		else
			//repairing glitches

			//if we're corrupted, create glitches
			if(corrupted)
				if(ticks_left_alternate == 1)
					target_glitch = locate() in src.loc
					if(!target_glitch)
						target_glitch = new(src.loc)
						src.visible_message("\icon[src] [src] has spawned a glitch in \icon[src.loc] [src.loc].")
					target_glitch = null
			else if(!target_glitch)
				target_glitch = locate() in range(10,src)

			//we have a target
			if(target_glitch)
				//move towards it if we're out of range
				if(get_dist(src, target_glitch) > 0)
					next_turf = get_step_to(src,target_glitch)
				else
					//stand still and repair it
					next_turf = src.loc
					target_glitch.repair(src)

		//patrol around
		if(!next_turf && target_patrol)
			target_turf = get_step_to(src,target_patrol)

		//wander around
		if(next_turf)
			wandering = 0
		else
			wandering = 1

		//actually move
		if(next_turf)
			for(var/obj/machinery/cyberspace/firewall/F in next_turf)
				F.attempt_open(src)
			Move(next_turf)
