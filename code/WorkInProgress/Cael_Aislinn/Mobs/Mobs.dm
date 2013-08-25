
//
/mob/cyberspace
	icon = 'code/WorkInProgress/Cael_Aislinn/Cyberspace.dmi'
	density = 0
	//
	faction = 1
	var/ticks_stunned = 0
	var/ticks_left_scan = 0
	var/maxHealth = 1
	var/health = 1
	var/authorised = 0
	var/flat_exp_award = 1
	//
	var/penetration = 0		//attack
	var/heuristics = 0		//defence
	var/analysis = 0		//detection
	var/infiltration = 0	//hiding
	var/malignancy = 0		//corrupting
	var/redundancy = 0		//corrupt resistance
	var/programming = 0		//building/unbuilding

	var/icon/corrupted
	var/obj/machinery/cyberspace/spawn_program/parent_spawner
	var/state

	var/wandering = 0
	var/ticks_left_wander = 0
	var/ticks_between_wander = 4
	var/last_scan_time = 0
	//
	var/ignore_circuits = 0
	var/corrupt_immune = 0

	var/mob/cyberspace/rider		//mob that is possessing this one, controlling it's actions
	var/mob/cyberspace/friend		//if this mob has been 'charmed' by another (see mob/cyberspace/minion)

/mob/cyberspace/New()
	..()
	health = maxHealth

/mob/cyberspace/Life()
	if(ticks_left_scan > 0)
		ticks_left_scan -= 1
	if(ticks_stunned > 0)
		ticks_stunned -= 1

	if(ticks_stunned <= 0)
		if(wandering)
			if(ticks_left_wander > 0)
				ticks_left_wander -= 1
			if(ticks_left_wander < 1)
				ticks_left_wander = ticks_between_wander
				var/list/L = list()
				for(var/turf/cyberspace/C in orange(1, src))
					if(!C.density)
						L.Add(C)
				if(L.len)
					Move( pick(L) )

/mob/cyberspace/proc/get_award_exp()
	return flat_exp_award

/mob/cyberspace/proc/attempt_attack(var/atom/movable/source)

	if(!source)
		return 0

	//penetration VS heuristics
	var/attack_strength = 1
	var/defence_strength = src.heuristics
	var/damage = 1

	//typechecks
	if( istype(source, /mob/cyberspace) )
		var/mob/cyberspace/C = source
		attack_strength = C.penetration
	else if( istype(source, /obj/effect/cyberspace_proj) )
		var/obj/effect/cyberspace_proj/C = source
		attack_strength = C.penetration
		damage = C.damage

	if(!attack_strength)
		return 0

	//turn them to face us
	source.dir = get_dir(source,src)

	//work whether the attack was successful
	var/probability = 100 * (attack_strength / (attack_strength + defence_strength) )
	if( !defence_strength || prob(probability) )
		health -= damage
		if(health <= 0)
			visible_message("<span class='warning'>\icon[source] [source] has wiped \icon[src] [src]!</span>")
			src.loc = null
			. = 2
		else
			source << "<span class='warning'>You partially wipe [src].</span>"
			src << "<span class='warning'><b>[source] has attempted to wipe you!</b></span>"
		return 1

/mob/cyberspace/proc/attempt_corrupt(var/mob/cyberspace/source)

	if(corrupt_immune)
		return 0
	if(!source)
		return 0

	//malignancy VS redundancy
	var/corrupt_strength = 0.01
	var/corrupt_defence = src.redundancy
	var/corrupt_success = 0

	//typechecks
	if( istype(source, /mob/cyberspace) )
		var/mob/cyberspace/C = source
		corrupt_strength = C.malignancy
	else if( istype(source, /obj/effect/cyberspace_proj) )
		var/obj/effect/cyberspace_proj/C = source
		corrupt_strength = C.malignancy
	else if( istype(source, /obj/machinery/cyberspace/glitch) )
		var/obj/machinery/cyberspace/glitch/C = source
		corrupt_strength = C.malignancy

	if(source && istype(source) )
		//turn them to face us
		source.dir = get_dir(source,src)
		corrupt_strength = source.malignancy

	//are we defenceless against it?
	if(!corrupt_defence)
		corrupt_success = 1
	else if(corrupt_strength)
		//work out the corruption probability
		var/probability = 100 * ( corrupt_strength / (corrupt_strength + corrupt_defence) )
		if(prob(probability))
			corrupt_success = 1

	//we've been corrupted
	if(corrupt_success)
		corrupted = new ('code/WorkInProgress/Cael_Aislinn/Cyberspace.dmi', "corrupt")
		visible_message("\icon[source] [source] has corrupted \icon[src] [src]!")
		underlays += corrupted
		name = "corrupt [initial(name)]"

	return corrupt_success

/mob/cyberspace/proc/detect_enemy_mob(var/scan_range = 7)
	if(ticks_stunned > 0)
		return

	//just return the first enemy mob we find
	if(scan_range > 1)
		last_scan_time = world.time
	for(var/mob/cyberspace/C in range(scan_range, src))
		if(C.ticks_left_scan <= 0)
			C.ticks_left_scan = 5
			if(C.scan(src))
				C << "\icon[src]<span class='warning'>Security scan failed. You do not belong here!</span>"
				return C
			else
				C << "\icon[src]<span class='info'>Security scan passed. Have a good day, entity.</span>"

/mob/cyberspace/proc/scan(var/mob/cyberspace/source)
	//if we've got a rider, scan them instead
	var/hostile = 0
	if(rider)
		hostile = rider.scan(source)
		if(hostile)
			return hostile

	//some mob types have special rules
	if(source)
		if(src.corrupted)
			//if we're corrupted
			if(src.faction)
				//if they're active security, let them know we're hostile
				hostile = 1
			else if(source.corrupted)
				//if they're corrupted or a virus, ignore us
				hostile = 0
		else
			if(source.corrupted)
				//if they're corrupted
				if(src.faction)
					//and we're a normal subroutine
					hostile = 1
				else
					//we're a virus, ignore us
					hostile = 0
			else
				//if they're uncorrupted
				if( (src.faction == source.faction) )
					//if we're a friend, ignore us
					hostile = 0
				else
					//we don't belong on this server, so forcibly remove us
					hostile = 1

	//for now, just autodetect enemies
	return hostile
	/*
	//if we can't hide at all, let them know we're here
	var/infiltrate_strength = src.infiltration
	if(!infiltrate_strength)
		return 1

	var/scan_strength = 1
	if(source)
		scan_strength = source.analysis

		//automatically pass the scan if it's too weak
		if(!scan_strength)
			return 0

	//roll the dice
	var/probability = 100 * (infiltrate_strength / (infiltrate_strength + scan_strength) )
	if(prob(probability))
		return 1
	*/

/mob/cyberspace/Crossed(var/atom/movable/O)
	..()
	if( istype(O, /obj/effect/cyberspace_proj) )
		var/obj/effect/cyberspace_proj/C = O
		C.hit_mob(src)

/mob/cyberspace/Cross(var/atom/movable/O)
	. = ..()
	if( istype(O, /obj/effect/cyberspace_proj) )
		var/obj/effect/cyberspace_proj/C = O
		C.hit_mob(src)

/mob/cyberspace/Click()
	//..()
	if( istype(usr, /mob/cyberspace/agent) )
		var/mob/cyberspace/agent/A = usr
		if(A.active_ability)
			A.active_ability.mob_extern_click(src)
