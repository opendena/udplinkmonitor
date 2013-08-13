config = require("./config")

PORT = config.PORT or 33333
HOST = config.HOST or "" 
 
dgram = require("dgram")
server = dgram.createSocket("udp4")
counter = 0
expectedLatency = config.expectedLatency or 40
nextt = (new Date()).getTime()
server.on "listening", ->
  address = server.address()
  console.log "UDP Server listening on " + address.address + ":" + address.port

server.on "message", (message, remote) ->
  tt = (new Date()).getTime()
  latency = tt-nextt
  console.log "[" + tt + "] OK " + remote.address + ":" + remote.port + " - [" + message + "] awaiting [" + counter + "] latency ["+latency+"]"

  recv = parseInt(message)
  if recv isnt counter
    onWrongCounter(counter,recv)
  
  if latency >= expectedLatency
    onLatency(counter,latency)

  counter = parseInt(message) + 1
  nextt = tt + 100


onWrongCounter = (counter,expectedValue) -> 
 console.log "Problem with counter ["+counter+"] Awaiting ["+expectedValue+"]"

onLatency = (counter,latency) ->
 console.log "Problem with latency counter ["+counter+"] latency is ["+latency+"]"

server.bind PORT, HOST
