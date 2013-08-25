
/obj/machinery/cyberspace/hourglass
	name = "hourglass"
	desc = "Oh dear, the processor must be overloaded."
	icon_state = "hourglass"
	density = 0
	var/ticks_left = 15

/obj/machinery/cyberspace/hourglass/process()
	ticks_left -= 1
	if(ticks_left <= 0)
		del(src)

/obj/machinery/cyberspace/hourglass/Crossed(atom/movable/Obstacle)
	. = ..()
	if(istype(Obstacle, /mob/cyberspace))
		var/mob/cyberspace/C = Obstacle
		C.ticks_stunned = max(0, C.ticks_stunned) + ticks_left
		C << "<span class='warning'>\icon[src] you are temporarily frozen!</span>"
