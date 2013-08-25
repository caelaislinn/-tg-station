
/datum/cyberspace_server
	var/text_name
	var/addr_octect_one
	var/addr_octect_two
	var/addr_octect_three
	var/addr_octect_four
	var/list/connected_ip_addresses = list()
	var/turf/alarmed_turf
	var/area_type
	var/list/virii = list()
	var/max_virii = 25

/datum/cyberspace_server/New()
	..()
	addr_octect_one = cyberspace_controller.global_octet_one
	addr_octect_two = cyberspace_controller.global_octet_one
	addr_octect_three = rand(1,999)
	addr_octect_four = rand(1,999)

/datum/cyberspace_server/proc/alarm_turf(var/turf/T)
	alarmed_turf = T

//
/area/cyberspace
	name = "cyberspace"
	desc = "The realm of the AI."
	icon = 'code/WorkInProgress/Cael_Aislinn/Cyberspace.dmi'
	icon_state = "area"
	/*luminosity = 1
	lighting_use_dynamic = 0*/

