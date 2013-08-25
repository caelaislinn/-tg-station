
//Scanner mob
/mob/cyberspace/scanner
	name = "scanner subroutine"
	desc = "Automated security monitoring subroutines. Watch out!"
	icon_state = "scanner2"
	//
	analysis = 1
	penetration = 1
	heuristics = 1
	redundancy = 10
	//
	maxHealth = 3
	authorised = 1
	ignore_circuits = 1

	var/mob/cyberspace/target

/mob/cyberspace/scanner/Life()
	..()

	//check if our target is still in range
	if(ticks_stunned <= 0)
		if(target)
			if(get_dist(src, target) < 2)
				if(target.attempt_attack(src) == 2)
					target = null
			else
				set_state(0)
		else
			set_state(0)
			if(world.time - last_scan_time > 30)
				target = detect_enemy_mob(1)
				if(target)
					set_state(1)
					target.ticks_stunned = 2
					spawn(1)
						if(target)
							target.Move(get_turf(src))

/mob/cyberspace/scanner/Move(NewLoc,Dir=0,step_x=0,step_y=0)
	..()
	if(!target)
		target = detect_enemy_mob(1)
		if(target)
			set_state(1)
			target.ticks_stunned = 2
			spawn(1)
				if(target)
					target.Move(get_turf(src))

/mob/cyberspace/scanner/proc/set_state(var/new_state = 0)
	switch(new_state)
		if(0)
			//force return to normal, even if we have a target
			state = 0
			icon_state = "scanner2"
			target = null
		if(1)
			//only start attacking if we have a valid target
			if(target)
				state = 1
				icon_state = "scanner1"
