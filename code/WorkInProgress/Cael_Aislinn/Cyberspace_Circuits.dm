

//CIRCUIT

/obj/machinery/cyberspace/circuit
	name = "circuit path"
	desc = "Data packets travel down these at lightning speeds."
	icon = 'code/WorkInProgress/Cael_Aislinn/Cyberspace_Circuits.dmi'
	icon_state = "circuit2"
	var/back_dir
	var/front_dir
	var/list/connected_dirs = list()

/obj/machinery/cyberspace/circuit/New()
	..()

	if( istype(src.loc, /turf/cyberspace) )
		var/turf/cyberspace/C = src.loc
		C.local_circuit = src

	spawn(0)
		for(var/checkDir in cardinal)
			var/obj/machinery/cyberspace/circuit/C = locate() in get_step(src,checkDir)
			if(C)
				connected_dirs.Add(checkDir)

//circuits are two way travel only, nodes handle multiway
/obj/machinery/cyberspace/circuit/proc/direct_mob(var/mob/cyberspace/C, var/oldDir)
	//world << "circuit/Crossed([Obj])"
	//if(!attempt_alarm(Obj))
	if(!C || C.ignore_circuits)
		return

	//move the atom on to the next turf
	//world << "check1"
	spawn(5)
		if(C && C.loc == src.loc && connected_dirs.len > 1 && connected_dirs.Find(oldDir))
			connected_dirs.Remove(oldDir)
			C.Move( get_step(src, pick(connected_dirs)) )
			connected_dirs.Add(oldDir)


//NODE
/*
/obj/machinery/cyberspace/node
	name = "circuit node"
	desc = "These direct data packets around the server."
	icon_state = "tronhub"
	var/list/connected_dirs = list()

/obj/machinery/cyberspace/node/New()
	..()
	if( istype(src.loc, /turf/cyberspace) )
		var/turf/cyberspace/C = src.loc
		C.circuit_machine = src


/obj/machinery/cyberspace/node/direct_mob(var/mob/cyberspace/C, var/oldDir)
	if(C.ignore_circuits)
		return

	if( connected_dirs.len && connected_dirs.Find(oldDir) )
		spawn(rand(5,10))
			if(C && C.loc == src.loc)
				connected_dirs.Remove(oldDir)
				var/new_dir = pick(connected_dirs)
				C.Move( get_step(src, new_dir) )
				connected_dirs.Add(oldDir)
*/