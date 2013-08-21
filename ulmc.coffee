config = require("./config")
program = require("commander")

program.version("0.0.1")
	.option("-f, --from <value>", "from identifier")
	.option("-p, --port <n>", "set destination server port [default=33000]", parseInt)
	.option("-h, --host [value]", "set destination server host")
	.option("-v, --verbose", "display some verbose")
	.parse process.argv

from = program.from or config.from  or 'ulmc'
PORT = program.port or config.PORT  or 33333
HOST =  program.host or config.HOST or 'localhost'

sendPacket = (pcounter)->
  message = new Buffer(JSON.stringify(
  	from: from
  	counter: pcounter
  ))
  
  pcounter = pcounter + 1

  if pcounter > 100
    pcounter = 0

  client.send message, 0, message.length, PORT, HOST, (err, bytes) ->
    throw err  if err
    if program.verbose
    	console.log "UDP message " + message + " sent to " + HOST + ":" + PORT


  setTimeout sendPacket, 100,pcounter

 
dgram = require("dgram")
counter = 0
client = dgram.createSocket("udp4")
sendPacket(counter)
