
/obj/machinery/cyberspace/spawn_program
	density = 0
	var/mob/cyberspace/my_spawn
	var/my_spawn_type

	var/ticks_building = 0
	var/ticks_to_build = 10

	var/regen_per_tick = 0.1
	var/accumulated_regen = 0
	var/max_accumulated_regen = 1

/obj/machinery/cyberspace/spawn_program/New()
	..()

	my_spawn = new my_spawn_type(src.loc)
	my_spawn.parent_spawner = src

/obj/machinery/cyberspace/spawn_program/process()
	if(accumulated_regen < max_accumulated_regen)
		accumulated_regen += regen_per_tick

	if(my_spawn && !my_spawn.corrupted)
		if(my_spawn.health < my_spawn.maxHealth && get_dist(src, my_spawn) < 2)
			var/amount = min(accumulated_regen, my_spawn.maxHealth - my_spawn.health)
			my_spawn.health += amount
			accumulated_regen -= amount
	else
		ticks_building += 1
		if(ticks_building >= ticks_to_build)
			ticks_building = 0
			my_spawn = new my_spawn_type(src.loc)
			my_spawn.parent_spawner = src
			visible_message("<span class='info'>\icon[src] [src] reinitializes \icon[my_spawn] [my_spawn].</span>")
