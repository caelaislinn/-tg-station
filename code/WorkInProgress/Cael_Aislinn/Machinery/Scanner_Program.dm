
/obj/machinery/cyberspace/spawn_program/scanner
	name = "scanner program"
	desc = "These scan for malicious activity, better keep your distance."
	icon_state = "scanner_prog"
	my_spawn_type = /mob/cyberspace/scanner
	layer = 3.2

	var/ticks_per_move = 1
	var/ticks_left_move = 0
	var/list/adj_turfs = list()
	var/list/scanner_ind = 1
	var/scanner_dir = 1

/obj/machinery/cyberspace/spawn_program/scanner/New()
	..()

	scanner_dir = pick(1,-1)
	scanner_ind = rand(1, 8)
	//
	adj_turfs.Add(get_step(src, NORTH))
	adj_turfs.Add(get_step(src, NORTHEAST))
	adj_turfs.Add(get_step(src, EAST))
	adj_turfs.Add(get_step(src, SOUTHEAST))
	adj_turfs.Add(get_step(src, SOUTH))
	adj_turfs.Add(get_step(src, SOUTHWEST))
	adj_turfs.Add(get_step(src, WEST))
	adj_turfs.Add(get_step(src, NORTHWEST))

/obj/machinery/cyberspace/spawn_program/scanner/process()
	..()

	if(my_spawn)
		ticks_left_move -= 1
		if(ticks_left_move <= 0 && !my_spawn.state)
			if(!my_spawn.loc)
				my_spawn = null
			//move in a circle around us
			ticks_left_move = ticks_per_move
			scanner_ind += scanner_dir
			while(scanner_ind > 8)
				scanner_ind -= 8
			while(scanner_ind < 1)
				scanner_ind += 8

			//move the scanner
			my_spawn.Move(adj_turfs[scanner_ind])
