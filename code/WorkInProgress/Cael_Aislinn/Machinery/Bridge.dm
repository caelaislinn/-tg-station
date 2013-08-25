
/obj/machinery/cyberspace/circuit/bridge
	name = "network bridge"
	desc = "These direct packets to other servers."
	icon_state = "bridge1"
	var/datum/cyberspace_server/target_server
	var/base_detect_chance = 8
	density = 0
	var/ticks_left_virus = 5
	var/max_ticks_per_virus = 15
	var/min_ticks_per_virus = 5
	var/list/spawned_malware = list()
	var/list/spawned_packets = list()
	var/list/packet_verify_index = 1

/obj/machinery/cyberspace/circuit/bridge/process()
	//increment out packet checker index
	packet_verify_index += 1
	if(packet_verify_index > spawned_packets.len)
		packet_verify_index = 1

	//only verify 1 packet per tick, to save processing
	if(spawned_packets.len)
		var/cut = 1
		if(spawned_packets[packet_verify_index])
			var/mob/M = spawned_packets[packet_verify_index]
			if(M.loc)
				cut = 0
		if(cut)
			spawned_packets.Cut(packet_verify_index, packet_verify_index+1)

	//limit spawned packets to 6
	if(spawned_packets.len < 6)
		var/mob/cyberspace/packet/P = new (src.loc)
		spawned_packets.Add(P)
		//flick("packet_in", P)

		spawn(3)
			P.Move(get_step(src, dir))

	if(ticks_left_virus > 0)
		ticks_left_virus -= 1
	else
		ticks_left_virus = rand(min_ticks_per_virus, max_ticks_per_virus)

		//check our malware to make sure they still exist
		for(var/index = 1, index < spawned_malware.len, index++)
			var/cut = 1
			if(spawned_malware[index])
				var/mob/M = spawned_malware[index]
				if(M.loc)
					cut = 0
			if(cut)
				spawned_malware.Cut(index, index+1)

		//limit spawned malware
		if(spawned_malware.len < 2)
			if(prob(5))
				spawned_malware.Add(new /mob/cyberspace/malware/daemon(src.loc))
			else
				spawned_malware.Add(new /mob/cyberspace/malware(src.loc))

/obj/machinery/cyberspace/circuit/bridge/Crossed(atom/movable/Obstacle)
	. = ..()
	if(istype(Obstacle, /mob/cyberspace/packet))
		var/mob/cyberspace/packet/P = Obstacle
		//flick("packet_out", P)
		spawn(3)
			del(P)
