udplinkmonitor
==============

Create continious and light UDP stream from host to host and warn on fail/loss


# Install & run #

    npm install -g coffee-script
	aptitude install rrdtool

then
 
	cp config.config.sample config.coffee
	coffee ulm.coffee

# How it works

When started, ulm take config.coffee and start a new UDP client for each occurence in servers configuration.
It begins to send packet with counter to server1.example.com:33333. Each packet as a new counter.
On server1.example.com, you must start another instance of ulm to receive and handle the packet.

# Configuration config.coffee #

	MASTER_HOST: "localhost" 
	MASTER_PORT: 33334 
	expectedLatency: 40 
	hitScript: "./bin/hitScript.sh"
	datastore: "/tmp/"
	from: "udplink"
	servers: 
	  serveralias1: "server1.example.com"
	  serveralias2: "server2.example.com"
	  localhost: "localhost"


