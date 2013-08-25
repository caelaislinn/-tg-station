
/obj/effect/cyberspace_proj
	name = "error"
	icon_state = "error"
	icon = 'code/WorkInProgress/Cael_Aislinn/Cyberspace.dmi'
	var/damage = 0.4
	var/penetration = 1
	var/turf/target_turf
	var/spawn_time = 0
	var/malignancy = 0
/*
/obj/effect/cyberspace_proj/New()
	pixel_x = rand(-3,3)
	pixel_y = rand(-3,3)
	spawn_time = world.time

	fire()

/obj/effect/cyberspace_proj/proc/fire()
	set background = 1

	spawn(0)
		while(src && src.loc)
			if(kill)
				src.loc = null
				return

			//move towards the target
			src.Move(get_step_towards(src, target_turf))

			//if we're there, clear us out
			if(src.loc == target_turf)
				src.loc = null
				return

			//if we timed out, clear us out
			if(world.time - spawn_time > 50)
				src.loc = null
				return

			//if we reached the edge of the world, clear us out
			/*
			if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))
				src.loc = null
				return
				*/

			sleep(1)

/obj/effect/cyberspace_proj/Bump(var/atom/Obstacle)
	. = ..()
	kill = 1
*/
/obj/effect/cyberspace_proj/proc/hit_mob(var/mob/cyberspace/C)
	//world << "[src] hit_mob([C])"
	if(src.loc && C.attempt_attack(src))
		src.loc = null
		//world << "proj killed mob"

/obj/effect/cyberspace_proj/processor
	name = "CPU hiccup"
	icon_state = "wait"
	damage = 0
	penetration = 0
	var/ticks_stun = 3

/obj/effect/cyberspace_proj/processor/hit_mob(var/mob/cyberspace/C)
	C.ticks_stunned += ticks_stun
	C << "\icon[src]<span class='warning'>You have been stunned by [src]!</span>"
	src.loc = null

/obj/effect/cyberspace_proj/corrupt
	name = "IO spoof"
	icon_state = "corrupt"
	damage = 0
	penetration = 0
	malignancy = 1

/obj/effect/cyberspace_proj/corrupt/hit_mob(var/mob/cyberspace/C)
	C.attempt_corrupt(src)
	src.loc = null
