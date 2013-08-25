
/obj/machinery/upload_console
	name = "Upload Console"
	desc = "The gateway to cyberspace."
	icon = 'code/WorkInProgress/Cael_Aislinn/Cyberspace.dmi'
	icon_state = "console1"
	var/area/linked_area

/obj/machinery/upload_console/New()
	..()
	linked_area = locate(/area/cyberspace/AI)

/obj/machinery/upload_console/attack_hand(var/mob/user as mob)
	if(!stat && user)
		user << "\icon[src]<span class='info'>[src] will upload you to: [linked_area], simply insert your cyberdeck to begin.</info>"

		//interact
		//
/*
/obj/machinery/upload_console/attackby(var/obj/I as obj, var/mob/user as mob)
	if( ishuman(user) && istype(I, /obj/item/cyberdeck) )
		var/obj/item/cyberdeck/C = I
		if(C.energy > 0)
			var/mob/living/carbon/human/H = user
		else
			user << "\icon[src]<span class='warning'>[C] does not have enough charge!</span>"
*/