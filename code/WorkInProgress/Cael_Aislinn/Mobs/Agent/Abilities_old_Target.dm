//targetted abilities
/datum/cyber_ability/target
	channelled_ability = 1
	var/cast_energy = 0
	cooldown_duration = 10
	var/range = 0
	var/valid_target_type

/datum/cyber_ability/target/New()
	..()
	activate_message = "Now using [src] on targets."
	deactivate_message = "No longer using [src] on targets."

/datum/cyber_ability/target/activate(var/mob/cyberspace/agent/A)
	if(!..())
		A.active_target_ability = src

/datum/cyber_ability/target/proc/cast(var/atom/targetted_atom)
	if(!casting_deck)
		return 1
	if(!active_agent)
		return 1
	if(!targetted_atom)
		return 1
	if(seconds_left_cooldown > 0)
		return 1
	if(casting_deck.energy < cast_energy)
		active_agent << "<span class='warning'>Could not activate [src]: not enough deck energy.</span>"
		return 1
	if( !istype(targetted_atom, valid_target_type) )
		return 1

	casting_deck.energy -= cast_energy
	seconds_left_cooldown = cooldown_duration
