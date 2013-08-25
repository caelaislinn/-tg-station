
/obj/machinery/cyberspace/firewall
	name = "firewall"
	desc = "Blocks data transfer, unless you can find an open port."
	icon = 'code/WorkInProgress/Cael_Aislinn/Cyberspace.dmi'
	icon_state = "tronwall_red"
	density = 1
	opacity = 1

/obj/machinery/cyberspace/firewall/proc/set_active(var/on = 1)
	if(on)
		icon_state = "tronwall_red"
		density = 1
		opacity = 1
	else
		icon_state = ""
		density = 0
		opacity = 0

/obj/machinery/cyberspace/firewall/proc/attempt_open(var/mob/cyberspace/C)
	if(!density)
		return

	var/open = 0
	if(C.authorised)
		open = 1

	if(open)
		visible_message("<span class='info'>\icon[src] [src] opens up for \icon[C] [C].</span>")
		set_active(0)
		spawn(50)
			set_active(1)
