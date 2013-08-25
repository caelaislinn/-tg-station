
//melee range abilities
/obj/effect/proc_holder/cyber_ability/wipe
	name = "Wipe subroutine"
	desc = "Attempt to wipe target subroutine from memory."
	energy_cost = 0
	self_target = 0
	penetration = 1
	target_range = 1

/obj/effect/proc_holder/cyber_ability/wipe/cast(var/atom/targetted_atom)
	if(targetted_atom && targetted_atom != src)
		var/mob/cyberspace/C = targetted_atom
		C.attempt_attack(caster)
