udplinkmonitor
==============

Create continious and light UDP stream from host to host and warn on fail/loss


# Install & run #

    npm install -g coffee-script
	aptitude install rrdtools

then
on server
 
	cp config.config.sample config.coffee
	coffee ulms.js

on client
	
	cp config.config.sample config.coffee
	coffee ulmc.js

# Help #


  Usage: ulmc.coffee [options]

  Options:

    -h, --help          output usage information
    -V, --version       output the version number
    -f, --from <value>  from identifier
    -p, --port <n>      set destination server port [default=33000]
    -h, --host [value]  set destination server host
    -v, --verbose       display some verbose


# Configuration config.coffee #

- **HOST** 	ip or name of the host

- **PORT** 	port you want to use

- **expectedLatency** Number of ms allowed between packets received before flapping bad link.

