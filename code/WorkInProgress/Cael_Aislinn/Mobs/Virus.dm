
/mob/cyberspace/malware
	name = "virus"
	icon_state = "virus"
	penetration = 1
	faction = 0
	var/attack_range = 0
	var/attacking = 0
	var/corrupts_left = 2
	corrupt_immune = 1
	malignancy = 0.1
	attack_range = 1

/mob/cyberspace/malware/Life()
	. = ..()
	attacking = 0

	//attack any mobs on top of us
	if(ticks_stunned <= 0)
		//attack nearby mobs
		for(var/mob/cyberspace/S in range(src,attack_range) - src)
			//don't attack other malware
			if(istype(S, /mob/cyberspace/malware))
				continue
			if(S.corrupted)
				continue

			//first, attempt to corrupt them
			var/result = 0
			if(corrupts_left > 0 && prob(50))
				result = S.attempt_corrupt(src)

			//if that fails, attack them
			if(result)
				corrupts_left -= 1
			else
				//if we kill them, regain a little health
				if(S.attempt_attack(src) == 2)
					health = min(health + 0.5, maxHealth)

			//while we're attacking, we can't do other things like wander or corrupt memory
			attacking = 1
			break

		//wander around
		if(attacking)
			wandering = 0
		else
			wandering = 1

/mob/cyberspace/malware/daemon
	name = "rogue daemon"
	icon_state = "daemon"
	maxHealth = 3
	ticks_between_wander = 2
	heuristics = 1
	malignancy = 0.5
	var/ticks_left_corrupt = 25
	corrupts_left = 3

/mob/cyberspace/malware/daemon/New()
	..()
	ticks_left_corrupt = rand(20,30)

/mob/cyberspace/malware/daemon/Life()
	..()
	if(ticks_stunned <= 0)
		if(!attacking)
			if(ticks_left_corrupt > 0)
				ticks_left_corrupt -= 1
			else
				var/obj/machinery/cyberspace/glitch/G = locate() in src.loc
				if(!G)
					G = new(src.loc)
					del(src)
