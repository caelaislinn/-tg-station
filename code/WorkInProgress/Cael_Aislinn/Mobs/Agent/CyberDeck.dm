
/obj/item/cyberdeck
	name = "cyberdeck"
	desc = "A passkey to cyberspace, better not lose it."
	var/max_energy = 300
	var/energy = 300
	var/last_charge_time = 0
	var/charge_rate = 1

	//agent stats
	var/maxHealth = 1
	var/authorised = 0
	var/experience = 0
	//
	var/penetration = 0		//attack
	var/heuristics = 0		//defence
	var/analysis = 0		//detection
	var/infiltration = 0	//hiding
	var/malignancy = 0		//corrupting
	var/redundancy = 0		//corrupt resistance
	var/programming = 0		//building/unbuilding

	var/datum/cyberspace_server/uploaded_server

	var/max_processing_power = 0
	var/list/active_abilities = list()

	//summonable minions
	var/max_minions = 1
	var/list/summoned_minions = list()

	//learnable abilities
	var/list/known_abilities = list()

/obj/item/cyberdeck/New()
	processing_objects.Add(src)
	//
	energy = max_energy
	last_charge_time = world.time

	//basic starter ability for player decks
	/*var/datum/cyber_ability/summon/clippy/C = new()
	known_abilities.Add(C)*/

/obj/item/cyberdeck/process()
	//work out if we're charging
	if(!uploaded_server && energy < max_energy)
		var/new_charge_time = world.time
		energy = min(energy + charge_rate * (new_charge_time - last_charge_time) / 10, max_energy)
		last_charge_time = new_charge_time

/*
/obj/item/cyberdeck/process/u_equip()

*/
