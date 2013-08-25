
/mob/cyberspace/repair
	name = "repair subroutine"
	icon_state = "ramiel_animfire"
	//
	programming = 1
	redundancy = 3
	//
	authorised = 1

	var/obj/machinery/cyberspace/glitch/target_glitch
	var/ticks_idle = 0
	ticks_between_wander = 3
	ignore_circuits = 1

/mob/cyberspace/repair/Life()
	..()

	if(ticks_stunned <= 0)
		var/turf/next_turf
		if(target_glitch)
			if(target_glitch.loc == src.loc)
				target_glitch.repair(src)
				next_turf = src.loc
			else
				next_turf = get_step_to(src,target_glitch)
		else
			if(!corrupted)
				target_glitch = locate() in range(src,10)
			if(!target_glitch)
				ticks_idle++
				if(corrupted)
					if(ticks_idle % 6 == 0)
						target_glitch = locate() in src.loc
						if(!target_glitch)
							target_glitch = new(src.loc)
							src.visible_message("<span class='warning'>\icon[src] [src] has spawned a glitch in \icon[src.loc] the memory sector!</span>")
						target_glitch = null
				else
					if(ticks_idle > 3 && parent_spawner)
						next_turf = get_step_to(src,parent_spawner)
			else
				ticks_idle = 0

		//move towards the target
		if(next_turf)
			for(var/obj/machinery/cyberspace/firewall/F in next_turf)
				F.attempt_open(src)
			Move(next_turf)
		else
			wandering = 1
