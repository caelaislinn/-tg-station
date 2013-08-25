/obj/effect/proc_holder/cyber_ability/shoot
	channelled_ability = 1
	cooldown_duration = 0
	energy_cost = 20
	self_target = 0
	penetration = 2
	var/proj_homing = 0
	var/proj_type
	var/proj_step_delay = 2
	var/proj_lifespan = 30
	var/last_loc

/obj/effect/proc_holder/cyber_ability/shoot/cast(var/atom/target, var/mob/cyberspace/agent/user = usr)
	spawn(0)
		var/atom/movable/projectile = new proj_type( get_turf(src) )
		projectile.dir = get_dir(user, target)
		projectile.pixel_x = rand(-4,4)
		projectile.pixel_y = rand(-4,4)
		var/last_dir = 0

		var/turf/target_turf = get_turf(target)
		for(var/i = 0,i < proj_lifespan,i++)

			sleep(proj_step_delay)

			last_loc = projectile.loc
			last_dir = src.dir
			if(proj_homing)
				step_to(projectile,target)
			else if(target_turf)
				step_to(projectile,target_turf)
				if(src.loc == target_turf)
					target_turf = null
			else
				step(projectile, last_dir)

			if(!projectile || !projectile.loc) // step and step_to sleeps so we'll have to check again.
				break

			if(projectile.loc == last_loc) //if it didn't move since last time
				projectile.loc = null
				break

			//don't worry about these yet
			/*if(proj_trail && projectile)
				spawn(0)
					if(projectile)
						var/obj/effect/overlay/trail = new /obj/effect/overlay(projectile.loc)
						trail.icon = proj_trail_icon
						trail.icon_state = proj_trail_icon_state
						trail.density = 0
						spawn(proj_trail_lifespan)
							del(trail)*/

		if(projectile)
			projectile.loc = null

//basic ranged attack
/obj/effect/proc_holder/cyber_ability/shoot/runtime
	name = "Runtime error"
	desc = "Shoots a rapidly moving error that can shut down running subroutines if not properly handled."
	proj_type = /obj/effect/cyberspace_proj

//basic ranged stun
/obj/effect/proc_holder/cyber_ability/shoot/processor
	name = "CPU spike"
	desc = "Shoots a rapidly moving CPU spike that can freeze running subroutines temporarily."
	cooldown_duration = 6
	energy_cost = 35
	malignancy = 1
	proj_type = /obj/effect/cyberspace_proj/processor

//basic ranged corrupt
/obj/effect/proc_holder/cyber_ability/shoot/corrupt
	name = "IO spoof"
	desc = "Shoots a rapidly moving spoof IO event that can corrupt running subroutines."
	cooldown_duration = 6
	energy_cost = 70
	penetration = 3
	malignancy = 3
	proj_type = /obj/effect/cyberspace_proj/corrupt
