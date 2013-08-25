/obj/effect/proc_holder/cyber_ability/summon
	var/list/summoned_minions = list()
	var/max_num_minions = 1
	channelled_ability = 1
	cooldown_duration = 10
	energy_cost = 100
	ongoing_energy_cost = 1
	var/spawn_type
	var/summon_msg
	var/desummon_msg

/obj/effect/proc_holder/cyber_ability/summon/cast_check(var/mob/cyberspace/agent/user = usr)
	//always be able to disable the ability
	if(currently_active)
		return 0
	. = ..()
	if(!.)
		if(!spawn_type)
			user << "<span class='warning'>Could not activate [src]: unable to determine subroutine ID.</span>"
			return 1
		if(summoned_minions.len >= max_num_minions)
			user << "<span class='warning'>Could not activate [src]: too many subroutines already spawned.</span>"
			return 1

/obj/effect/proc_holder/cyber_ability/summon/cast(var/atom/target, var/mob/cyberspace/agent/user = usr)
	if(spawn_type)
		var/mob/cyberspace/M = new spawn_type(get_turf(src))
		M.friend = user
		summoned_minions.Add(M)
		if(summon_msg)
			M.visible_message("\icon[M] [summon_msg]")

/obj/effect/proc_holder/cyber_ability/summon/deactivate_cast(var/mob/cyberspace/agent/user = usr)
	for(var/mob/M in summoned_minions)
		summoned_minions.Remove(M)
		if(desummon_msg)
			M.visible_message("\icon[M] [desummon_msg]")
		M.loc = null

/obj/effect/proc_holder/cyber_ability/summon/clippy
	name = "Summon Clippy"
	desc = "A friendly and devoted personal assistant."
	spawn_type = /mob/cyberspace/minion/clippy
	summon_msg = "Clippy appears in a puff of office stationery!"
	desummon_msg = "Clippy disappears in a puff of office stationery!"

/obj/effect/proc_holder/cyber_ability/summon/merlin
	name = "Summon Merlin"
	desc = "A wizardly personal assistant, powerful and wise."
	spawn_type = /mob/cyberspace/minion/merlin
	summon_msg = "Merlin appears in a puff of wizardry!"
	desummon_msg = "Merlin disappears back to his tower!"
