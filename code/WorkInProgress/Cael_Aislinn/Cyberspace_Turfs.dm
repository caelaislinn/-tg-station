
//
/turf/cyberspace
	name = "memory"
	desc = "The server's virtual memory pool."
	icon = 'code/WorkInProgress/Cael_Aislinn/Cyberspace.dmi'
	icon_state = "floor2"
	var/special_id = " "
	var/locked = 0
	var/closed_gates = 0
	var/base_detect_chance = 1
	var/obfuscated = 1
	var/datum/cyberspace_server/host_server
	var/locked_dirs = 0
	var/obj/machinery/cyberspace/circuit/local_circuit

/turf/cyberspace/New()
	..()
	/*if(!special_id)
		special_id = pick("A","B","C","D","E") + pick("A","B","C","D","E") + "-" + rand(0,9) + rand(0,9) + rand(0,9)*/

/turf/cyberspace/proc/attempt_alarm(atom/movable/Obj)
	//By default, no alarm was triggered by this mob
	var/alarm = 0

	var/hide_chance = 0
	if(istype(Obj, /mob))
		if(istype(Obj, /mob/cyberspace/packet))
			var/mob/cyberspace/packet/P = Obj
			if(P.riding_agent)
				//Agents disguised as packets have a reduced detection probability
				hide_chance = P.riding_agent.hide_chance * 2
		else if(!istype(Obj, /mob/cyberspace))
			//Purge non cyber entities
			alarm = 1

	if(hide_chance)
		var/total_chance = hide_chance + base_detect_chance
		if(prob( 100 * (base_detect_chance / total_chance) ))
			alarm = 1
			host_server.alarm_turf(src)
			overlays += "alarm"

			//repeated code here
			if(!locked)
				locked = 1
				overlays += "lock"

			//there might be a better way to do this
			for(var/curdir in cardinal)
				if( !(locked_dirs & curdir) )
					locked_dirs &= curdir
					var/icon/I = new('Cyberspace.dmi', "gates", curdir)
					overlays += I

			src.visible_message("\icon[src] [src] has detected something suspicious in \icon[Obj] [Obj]!")

	return alarm

/turf/cyberspace/proc/lock(var/dirs = 0)
	if(!locked)
		locked = 1
		overlays += "lock"

	//there might be a better way to do this
	for(var/curdir in cardinal)
		if( (dirs & curdir) && !(locked_dirs & curdir) )
			locked_dirs &= curdir
			var/icon/I = new('Cyberspace.dmi', "gates", curdir)
			overlays += I

/turf/cyberspace/proc/unlock(var/dirs = 0)

	//there might be a better way to do this
	for(var/curdir in cardinal)
		if( (dirs & curdir) && (locked_dirs & curdir) )
			locked_dirs &= ~curdir
			var/icon/I = new('Cyberspace.dmi', "gates", curdir)
			overlays -= I

/turf/cyberspace/proc/disable_lock()
	if(locked)
		locked = 0
		overlays -= "lock"

/turf/cyberspace/proc/toggle_obfuscate()
	if(obfuscated)
		obfuscated = 0
		name = initial(name) + " " + special_id
	else
		obfuscated = 1
		name = initial(name)

/turf/cyberspace/Entered(atom/movable/Obj, atom/OldLoc)
	. = ..()

	if( istype(Obj, /mob/cyberspace) && local_circuit )
		local_circuit.direct_mob(Obj, get_dir(src, OldLoc))

		/*for(var/mob/cyberspace/scanner/S in cached_adj_scanners)
			if(get_dist(src, S) > 1)
				cached_adj_scanners.Remove(S)
			else
				S.auth_check(Obj)*/
	//attempt_alarm(Obj)

/*/turf/cyberspace/Enter(atom/movable/O, atom/oldloc)
	if(..())
		//check to see if the adjacent cyberspace turf is blocking in this dir
		if(istype(oldloc, /turf))
			if(istype(oldloc, /turf/cyberspace))
				var/turf/cyberspace/C = oldloc
				var/oldDir = get_dir(C, src)
				if(C.locked_dirs & oldDir)
					return 0

			//check to see if we're blocking in that dir
			var/turf/T = oldloc
			var/oldDir = get_dir(src, T)
			if(locked_dirs & oldDir)
				return 0

	return 1*/
