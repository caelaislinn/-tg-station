
//Scanner node
/obj/machinery/cyberspace/glitch
	name = "glitched sector"
	desc = "The code must have got corrupted."
	icon = 'code/WorkInProgress/Cael_Aislinn/Cyberspace.dmi'
	icon_state = "matrixfloor"
	density = 0
	var/ticks_left_virus = 3
	var/max_ticks_per_virus = 8
	var/min_ticks_per_virus = 2
	var/ticks_left_repair = 5
	layer = 3.1
	var/list/spawned_malware = list()
	var/malignancy = 1

/obj/machinery/cyberspace/glitch/proc/repair(var/mob/cyberspace/C)
	if(C)
		ticks_left_repair -= C.programming
		if(ticks_left_repair <= 0)
			visible_message("<span class='info'>\icon[C] [C] has formatted \icon[src] [src].</span>")
			del(src)

/obj/machinery/cyberspace/glitch/process()
	if(ticks_left_virus > 0)
		ticks_left_virus -= 1
	else
		ticks_left_virus = rand(min_ticks_per_virus, max_ticks_per_virus)

		//check over our malware to make sure it's still functional
		for(var/index = 1, index < spawned_malware.len, index++)
			var/cut = 1
			if(spawned_malware[index])
				var/mob/M = spawned_malware[index]
				if(M.loc)
					cut = 0
			if(cut)
				spawned_malware.Cut(index, index+1)

		//limit spawned malware
		if(spawned_malware.len < 3)
			if(prob(10))
				spawned_malware.Add(new /mob/cyberspace/malware/daemon(src.loc))
			else
				spawned_malware.Add(new /mob/cyberspace/malware(src.loc))

/obj/machinery/cyberspace/glitch/Crossed(atom/movable/Obstacle)
	. = ..()
	if( istype(Obstacle, /mob/cyberspace))
		var/mob/cyberspace/C = Obstacle
		if(!C.corrupted && !C.corrupt_immune)
			C.attempt_corrupt(src)
