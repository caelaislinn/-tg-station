
var/datum/controller/cyberspace/cyberspace_controller = new()

/datum/controller/cyberspace
	var/list/all_servers = list()
	var/num_servers = 0
	var/square_server_dims = 10
	var/global_octet_one
	var/global_octet_two

/datum/controller/cyberspace/New()
	..()

	//Create a new zlevel to hold our instances of cyberspace
	world.maxz += 1

	//setup global ips
	global_octet_one = rand(1,999)
	global_octet_two = rand(1,999)

/datum/controller/cyberspace/proc/create_new_server()
	set background = 1
	/*
	spawn(0)
		for(var/i = 1, i < square_server_dims, i++)
			//create bottom border
			new /turf/cyberspace/buffer( locate(i, 1, world.maxz) )
	spawn(0)
		for(var/i = 1, i < square_server_dims, i++)
			//create top border
			new /turf/cyberspace/buffer( locate(i + 1, square_server_dims, world.maxz) )
	spawn(0)
		for(var/i = 1, i < square_server_dims, i++)
			//create left border
			new /turf/cyberspace/buffer( locate(1, i + 1, world.maxz) )
	spawn(0)
		for(var/i = 1, i < square_server_dims, i++)
			//create right border
			new /turf/cyberspace/buffer( locate(square_server_dims, i, world.maxz) )
			*/

	/*spawn(0)
		//create interior
		for(var/j = i + 1, j < square_server_dims - i, j++)
			new /turf/cyberspace/buffer( locate(i, 1, world.maxz) )*/

	//increment the number of servers
	num_servers++
