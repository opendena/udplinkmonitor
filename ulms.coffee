config = require("./config")
storage = require("node-persist")
dgram = require("dgram")

PORT = config.PORT or 33333
HOST = config.HOST or "" 

storage.initSync();

storage.setItem "stats5", 0  unless storage.getItem("stats5")

ilinkTimeout = {}

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

  jmessage = JSON.parse(message)

  from = jmessage.from
  recv = parseInt(jmessage.counter)
    

  if !ilinkTimeout[from] 
    console.log "started new hitX for "+from
    ilinkTimeout[from] = {}
    ilinkTimeout[from].nextHit = hitX(from+"-5",5)

  if recv isnt counter
    onWrongCounter(from,counter,recv)
    if recv < counter
      i = counter
      while i < 101
        ilinkTimeout[from][i] = ""
        i++
      i = 0
      while i < counter
        ilinkTimeout[from][i] = ""
        i++
    else
      i = counter
      while i < recv
        ilinkTimeout[from][i] = ""
        i++


  if latency >= expectedLatency
    onLatency(from,counter,latency)
  
  onMessage(from,counter,latency)

  ilinkTimeout[from][recv] = latency
  console.log ilinkTimeout[from]

  counter = recv + 1
  if counter > 100
    counter = 0

  nextt = tt + 100



hitX = (from,value) ->
  console.log "Heartbeat "+value+" secondes..."
  
  stats = storage.getItem("stats"+value);
  if stats is null 
    stats = value*10

  sys = require('sys')
  exec = require('child_process').exec
  
  nbExpected = value*10
  child = exec(config.latencyError + " " + from + " " + nbExpected + " "+stats+" "+((nbExpected-stats)/nbExpected)*100 + " " + JSON.stringify(ilinkTimeout[from]), (error, stdout, stderr) ->
    sys.print (from + ' stdout: ' + stdout)
  )

  storage.setItem "stats"+value, null
  # On repart pour un tour
  timeoutId = setTimeout (->
      hitX(from,value)
    ), (value*1000)+100;

  return timeoutId;





onMessage = (from,counter,expectedValue) -> 
  #console.log "Got hit ["+counter+"] I'm alive anyway.."

  storage.setItem "stats5", 0  unless storage.getItem("stats5")
  stats5 = storage.getItem("stats5");
  #console.log "Stats5 is " + stats5
  storage.setItem "stats5", stats5


onWrongCounter = (from,counter,expectedValue) -> 
  console.log "Problem with counter ["+counter+"] Awaiting ["+expectedValue+"]"

  storage.setItem "stats5", 0  unless storage.getItem("stats5")
  stats5 = storage.getItem("stats5");
  stats5++;
  console.log "Stats5 is " + stats5
  storage.setItem "stats5", stats5


onLatency = (from,counter,latency) ->
  console.log "Problem with latency counter ["+counter+"] latency is ["+latency+"]"
  storage.setItem "stats5", 0  unless storage.getItem("stats5")
  stats5 = storage.getItem("stats5");
  stats5++;
  console.log "Stats5 is " + stats5
  storage.setItem "stats5", stats5


server.bind PORT, HOST
