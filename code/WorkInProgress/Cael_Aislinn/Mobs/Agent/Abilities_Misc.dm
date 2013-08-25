/obj/effect/proc_holder/cyber_ability/check_energy
	name = "Check Energy level"
	desc = "Activate to display your energy level."

/obj/effect/proc_holder/cyber_ability/check_energy/New()
	..()
	processing_objects.Add(src)
	if( istype(src.loc, /mob/cyberspace/agent) )
		caster = src.loc

/obj/effect/proc_holder/cyber_ability/check_energy/process()
	if(caster)
		stat_desc = "[caster.energy]E remaining"

/obj/effect/proc_holder/cyber_ability/check_energy/Click()
	var/mob/cyberspace/agent/user = usr
	user.visible_message("\icon[user] [user] has [user.energy]E remaining!")
