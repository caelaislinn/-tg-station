
/mob/cyberspace/hunter_seeker
	name = "hunter_seeker subroutine"
	desc = "Sleek, fast and deadly. Better keep your distance if you don't belong."
	icon_state = "hunterseeker"
	//
	analysis = 3
	penetration = 3
	heuristics = 4
	redundancy = 20
	//
	maxHealth = 8
	authorised = 1
	ignore_circuits = 1

	var/mob/cyberspace/target

/mob/cyberspace/hunter_seeker/Life()
	..()

	//check if our target is still in range
	if(ticks_stunned <= 0)
		if(target)
			if(get_dist(src, target) < 2)
				if(target.attempt_attack(src) == 2)
					target = null
		else
			if(world.time - last_scan_time > 30)
				target = detect_enemy_mob(10)

		//move to the target
		for(var/move_num = 0, move_num < 3, move_num++)
			spawn(move_num * 5)
				if( target && get_dist(src,target) > 1 )
					var/turf/next_turf = get_step_to(src, target)
					for(var/obj/machinery/cyberspace/firewall/F in next_turf)
						F.attempt_open(src)
					Move(next_turf)
