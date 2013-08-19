config = require("./config")
storage = require("node-persist")
dgram = require("dgram")

PORT = config.PORT or 33333
HOST = config.HOST or "" 

storage.initSync();

storage.setItem "stats5", 0  unless storage.getItem("stats5")
storage.setItem "stats30", 0  unless storage.getItem("stats30")
storage.setItem "stats60", 0  unless storage.getItem("stats60")
storage.setItem "stats300", 0 unless storage.getItem("stats300")

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
  #console.log "[" + tt + "] OK " + remote.address + ":" + remote.port + " - [" + message + "] awaiting [" + counter + "] latency ["+latency+"]"

  recv = parseInt(message)
  if recv isnt counter
    onWrongCounter(counter,recv)
  
  if latency >= expectedLatency
    onLatency(counter,latency)

  counter = parseInt(message) + 1
  nextt = tt + 100


hit5 = () ->
  console.log "Heartbeat 5 secondes..."
  
  stats5 = storage.getItem("stats5");
  sys = require('sys')
  exec = require('child_process').exec
  
  child = exec(config.latencyError + " " + 50 + " "+stats5+" "+((50-stats5)/50)*100, (error, stdout, stderr) ->
    sys.print ('stdout: ' + stdout)
  )

  storage.setItem "stats5", 0
  # On repart pour un tour
  setTimeout (->
    hit5()
  ), 5100

#hit5();


hitX = (value) ->
  console.log "Heartbeat "+value+" secondes..."
  
  stats = storage.getItem("stats"+value);
  sys = require('sys')
  exec = require('child_process').exec
  
  nbExpected = value*10
  child = exec(config.latencyError + " " + nbExpected + " "+stats+" "+((nbExpected-stats)/nbExpected)*100, (error, stdout, stderr) ->
    sys.print ('stdout: ' + stdout)
  )

  storage.setItem "stats"+value, 0
  # On repart pour un tour
  setTimeout (->
    hitX(value)
  ), (value*1000)+100;

hitX(5)
hitX(30)

onWrongCounter = (counter,expectedValue) -> 
  console.log "Problem with counter ["+counter+"] Awaiting ["+expectedValue+"]"

  storage.setItem "stats5", 0  unless storage.getItem("stats5")
  stats5 = storage.getItem("stats5");
  stats5++;
  console.log "Stats5 is " + stats5
  storage.setItem "stats5", stats5

  storage.setItem "stats30", 0  unless storage.getItem("stats30")
  stats30 = storage.getItem("stats30");
  stats30++;
  console.log "stats30 is " + stats30
  storage.setItem "stats30", stats30


onLatency = (counter,latency) ->
  console.log "Problem with latency counter ["+counter+"] latency is ["+latency+"]"
  storage.setItem "stats5", 0  unless storage.getItem("stats5")
  stats5 = storage.getItem("stats5");
  stats5++;
  console.log "Stats5 is " + stats5
  storage.setItem "stats5", stats5

  storage.setItem "stats30", 0  unless storage.getItem("stats30")
  stats30 = storage.getItem("stats30");
  stats30++;
  console.log "stats30 is " + stats30
  storage.setItem "stats30", stats30

server.bind PORT, HOST
