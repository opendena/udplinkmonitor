PORT = 33333
HOST = ""
dgram = require("dgram")
server = dgram.createSocket("udp4")
counter = 0
expectedLatence = 40
nextt = (new Date()).getTime()
server.on "listening", ->
  address = server.address()
  console.log "UDP Server listening on " + address.address + ":" + address.port

server.on "message", (message, remote) ->
  tt = (new Date()).getTime()
  console.log "[" + tt + "] " + remote.address + ":" + remote.port + " - [" + message + "] awaiting [" + counter + "]"
  recv = parseInt(message)
  console.log "Problem [" + (tt - nextt) + "] [" + recv + "/" + counter + "]"  if ((tt - nextt) >= expectedLatence) or (recv isnt counter)
  counter = parseInt(message) + 1
  nextt = tt + 100

server.bind PORT, HOST
