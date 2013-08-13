sendPacket = ->
  message = new Buffer("" + counter)
  counter++
  client.send message, 0, message.length, PORT, HOST, (err, bytes) ->
    throw err  if err
    console.log "UDP message " + message + " sent to " + HOST + ":" + PORT

  setTimeout sendPacket, 100
PORT = 33333
HOST = ""
dgram = require("dgram")
counter = 0
message = new Buffer("" + counter)
client = dgram.createSocket("udp4")
sendPacket()
