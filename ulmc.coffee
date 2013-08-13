config = require("config")


sendPacket = ->
  message = new Buffer("" + counter)
  counter++
  client.send message, 0, message.length, PORT, HOST, (err, bytes) ->
    throw err  if err
    console.log "UDP message " + message + " sent to " + HOST + ":" + PORT

  setTimeout sendPacket, 100

PORT = config.PORT or 33333
HOST = config.HOST or localhost
 
dgram = require("dgram")
counter = 0
message = new Buffer("" + counter)
client = dgram.createSocket("udp4")
sendPacket()
