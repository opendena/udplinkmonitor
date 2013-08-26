config = require("./config")
dgram = require("dgram")

client = dgram.createSocket("udp4")

verbose = false

sendPacket = (pcounter,from,HOST,PORT)->
  message = new Buffer(JSON.stringify(
  	from: from
  	counter: pcounter
  ))
  
  pcounter = pcounter + 1

  if pcounter > 100
    pcounter = 0

  client.send message, 0, message.length, PORT, HOST, (err, bytes) ->
    throw err  if err
    if verbose
    	console.log "UDP message " + message + " sent to " + HOST + ":" + PORT


  setTimeout sendPacket, 100, pcounter, from, HOST, PORT
 
counter = 0

module.exports.start = (from,HOST,PORT) ->
    sendPacket(counter,from,HOST,PORT)


