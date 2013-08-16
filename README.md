udplinkmonitor
==============

Create continious and light UDP stream from host to host and warn on fail/loss


# Install & run #

    npm install -g coffee-script

then
on server 

	coffee ulms.js

on client
 
	 coffee ulmc.js


# Configuration #

- **HOST** 	ip or name of the host

- **PORT** 	port you want to use

- **expectedLatency** Number of ms allowed between packets received before flapping bad link.

