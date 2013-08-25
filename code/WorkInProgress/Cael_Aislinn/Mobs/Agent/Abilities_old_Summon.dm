
//generic summon abilities
/datum/cyber_ability/summon
	var/max_minion_num = 1
	var/summon_type
	channelled_ability = 1
	var/mob/cyberspace/summoned_minion
	programming = 1

/datum/cyber_ability/summon/New()
	..()

/datum/cyber_ability/summon/activate(var/mob/cyberspace/agent/A)
	if(!..())
		if(casting_deck.summoned_minions.len >= casting_deck.max_minions)
			A << "<span class='warning'>You have too many programs already!</span>"
		summoned_minion = new summon_type(A.loc)
		casting_deck.summoned_minions.Add(summoned_minion)

/datum/cyber_ability/summon/deactivate(var/mob/cyberspace/agent/A)
	..()
	//clear out our minion
	if(summoned_minion)
		casting_deck.summoned_minions.Remove(summoned_minion)
		summoned_minion.loc = null

	//remove any nulls, just in case
	for(var/index=1, index <= casting_deck.summoned_minions.len, index++)
		if(!casting_deck.summoned_minions[index])
			casting_deck.summoned_minions.Cut(index, index + 1)

/datum/cyber_ability/summon/process()
	if(!summoned_minion && currently_active)
		deactivate()
	..()

//starter ability for humans
/datum/cyber_ability/summon/clippy
	name = "Summon Clippy"
	desc = "A faithful friend to help you out."

	activate_message = "Clippy appears in a puff of office stationery!"
	deactivate_message = "Clippy disappears back to the office draw he came from!"

	activate_energy_cost = 100
	ongoing_energy_cost = 10
	cooldown_duration = 100
	summon_type = /mob/cyberspace/minion/clippy

//starting ability for silicons
/datum/cyber_ability/summon/merlin
	name = "Summon Merlin"
	desc = "A powerful wizard to defend you from harm."

	activate_message = "Merlin appears in a puff of wizardry!"
	deactivate_message = "Merlin disappears back to the tower he came from!"

	activate_energy_cost = 150
	ongoing_energy_cost = 15
	cooldown_duration = 100
	summon_type = /mob/cyberspace/minion/merlin
