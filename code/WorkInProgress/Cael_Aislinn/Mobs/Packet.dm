
/mob/cyberspace/packet
	name = "data file"
	desc = "Bits and bytes streaming down an information superhighway."
	icon_state = "document"
	var/mob/cyberspace/agent/riding_agent
	density = 0
	authorised = 1

/mob/cyberspace/packet/New()
	..()
	pixel_x = rand(-8,8)
	pixel_y = rand(-8,8)
	if(prob(50))
		icon_state = pick("ie","chrome","safari","mac","linux","opera","windows","access","publisher","word","excel","outlook","powerpoint","infopath")
