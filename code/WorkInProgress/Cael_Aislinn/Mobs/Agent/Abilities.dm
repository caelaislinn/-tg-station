
/obj/effect/proc_holder/cyber_ability
	name = null
	density = 0
	opacity = 0

	var/charges_left = 1		//for limited use spells
	var/require_charges = 0
	//
	var/cooldown_duration = 0	//cooldown in seconds
	var/cooldown_left = 0		//cooldown in seconds

	var/energy_cost = 10			//10 energy = 1 second of life time
	var/ongoing_energy_cost = 0		//additional energy required to maintain (every second)

	//var/obj/item/cyberdeck/casting_deck
	//var/mob/cyberspace/agent/active_agent

	var/channelled_ability = 0		//whether it's a fire-and-forget or a channeled ability
	var/self_target = 1
	var/target_range = 7
	//
	var/mob/cyberspace/agent/caster
	var/activate_message
	var/deactivate_message
	var/currently_active = 0
	var/processing = 0
	var/stat_desc

	//required stats
	var/penetration = 0		//attack
	var/heuristics = 0		//defence
	var/analysis = 0		//detection
	var/infiltration = 0	//hiding
	var/malignancy = 0		//corrupting
	var/redundancy = 0		//corrupt resistance
	var/programming = 0		//building/unbuilding

	var/last_process_time = 0

/obj/effect/proc_holder/cyber_ability/New()
	last_process_time = world.time

/obj/effect/proc_holder/cyber_ability/process()
	var/deltaT = (world.time - last_process_time) * 0.1
	last_process_time = world.time
	processing = 0

	//cooldown
	if(cooldown_left > 0)
		cooldown_left -= deltaT
		processing = 1

	//handle energy consumption if we're channeling it
	if(currently_active)

		var/cost = deltaT * ongoing_energy_cost
		if(caster.energy - cost <= 0)
			deactivate_cast()
		else
			caster.energy -= cost
		processing = 1

	if(!processing)
		..()

/obj/effect/proc_holder/cyber_ability/proc/cast_check(var/mob/cyberspace/agent/user = usr)
	//generic fail conditions
	//world << "cast_check([user] [user.type])"
	if( !user || !istype(user) )
		return 1
	/*if(!user.casting_deck)
		user << "<span class='warning'>Could not activate [src]: cyberdeck not responding.</span>"
		return 1*/
	/*if(currently_active)
		user << "<span class='warning'>Could not activate [src]: ability already active.</span>"
		return 1*/

	//cast fail checks
	if(user.energy < energy_cost)
		user << "<span class='warning'>Could not activate [src]: not enough energy.</span>"
		return 1
	if(cooldown_left > 0)
		if(cooldown_duration >= 5)
			user << "<span class='warning'>Could not activate [src]: ability on cooldown.</span>"
		return 1
	if(require_charges && charges_left <= 0)
		user << "<span class='warning'>Could not activate [src]: not enough charges left.</span>"
		return 1

	//skill fail conditions
	if(user.penetration < src.penetration)
		user << "<span class='warning'>Could not activate [src]: you require [src.penetration] penetration skill (have [user.penetration]).</span>"
		return 1
	if(user.heuristics < src.heuristics)
		user << "<span class='warning'>Could not activate [src]: you require [src.heuristics] heuristics skill (have [user.heuristics]).</span>"
		return 1
	if(user.analysis < src.analysis)
		user << "<span class='warning'>Could not activate [src]: you require [src.analysis] analysis skill (have [user.analysis]).</span>"
		return 1
	if(user.infiltration < src.infiltration)
		user << "<span class='warning'>Could not activate [src]: you require [src.infiltration] infiltration skill (have [user.infiltration]).</span>"
		return 1
	if(user.malignancy < src.malignancy)
		user << "<span class='warning'>Could not activate [src]: you require [src.malignancy] malignancy skill (have [user.malignancy]).</span>"
		return 1
	if(user.redundancy < src.redundancy)
		user << "<span class='warning'>Could not activate [src]: you require [src.redundancy] redundancy skill (have [user.redundancy]).</span>"
		return 1
	if(user.programming < src.programming)
		user << "<span class='warning'>Could not activate [src]: you require [src.programming] programming skill (have [user.programming]).</span>"
		return 1

/obj/effect/proc_holder/cyber_ability/proc/before_cast(var/mob/cyberspace/agent/user = usr)
	user.energy -= energy_cost
	if(require_charges)
		charges_left -= 1

	cooldown_left = cooldown_duration		//reset cooldown

	caster = user
	if(activate_message)
		user << "\icon[user.casting_deck]<span class='info'>[activate_message]</span>"

	if(channelled_ability)
		currently_active = 1

	if(!processing)
		processing_objects.Add(src)
		processing = 1

/obj/effect/proc_holder/cyber_ability/proc/cast(var/atom/target, var/mob/cyberspace/agent/user = usr)
	target.visible_message("\icon[target] \red[target] was hit by [src.name]!")

/obj/effect/proc_holder/cyber_ability/proc/before_deactivate_cast(var/mob/cyberspace/agent/user = usr)
	if(deactivate_message)
		user << "\icon[user.casting_deck]<span class='info'>[deactivate_message]</span>"
	cooldown_left = cooldown_duration		//reset cooldown
	currently_active = 0

	if(!processing)
		processing_objects.Add(src)
		processing = 1

/obj/effect/proc_holder/cyber_ability/proc/deactivate_cast(var/mob/cyberspace/agent/user = usr)

/obj/effect/proc_holder/cyber_ability/proc/choose_target(var/mob/cyberspace/user = usr)
	if(self_target)
		return user

	var/list/possible_targets = list()
	for(var/mob/cyberspace/target in view(target_range, user))
		possible_targets += target

	return input("Choose the target for the ability.", "Targeting [src.name]") as mob in possible_targets
/*
/obj/effect/proc_holder/cyber_ability/DblClick()
	//..()
	world << "DblClick()"
	if(self_target)
		world << "DblClick/check1"
		Click()
	else if(!cast_check())
		world << "DblClick/check2"
		var/mob/cyberspace/target = choose_target()
		if(target)
			world << "DblClick/check3"
			before_cast()
			cast(target)
*/
/obj/effect/proc_holder/cyber_ability/Click()
	//..()

	if(self_target)
		if(currently_active)
			before_deactivate_cast()
			deactivate_cast()
		else if(!cast_check())
			var/mob/cyberspace/target = choose_target()
			before_cast()
			cast(target)
	else
		if( istype(usr, /mob/cyberspace/agent) )
			caster = usr
		if(caster)
			if(caster.active_ability == src)
				caster << "<span class='info'>No longer activating [caster.active_ability.name] on click.</span>"
				caster.active_ability = null
			else
				caster.active_ability = src
				caster << "<span class='info'>Now activating [src.name] where you click.</span>"

/obj/effect/proc_holder/cyber_ability/proc/mob_extern_click(var/mob/cyberspace/source)
	//when a player clicks on something in cyberspace, that atom redirects the click to the current active ability
	//world << "[src] mob_extern_click([source])"
	if(!self_target && source && !cast_check())
		//world << "mob_extern_click/check1"
		if(get_dist(source, get_turf(src)) <= target_range)
			before_cast()
			cast(source)
