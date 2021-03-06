config = require("./config")

dgram = require("dgram")

sys = require('sys')
exec = require('child_process').exec

PORT = config.PORT or 33333
HOST = config.HOST or "" 

storage = {}
ilinkTimeout = {}

server = dgram.createSocket("udp4")
client = dgram.createSocket("udp4")
verbose = true;

expectedLatency = config.expectedLatency or 40
nextt = (new Date()).getTime()

server.on "listening", ->
  address = server.address()
  console.log "UDP Server listening on " + address.address + ":" + address.port


server.on "message", (message, remote) ->
  tt = (new Date()).getTime()
  isOK = true;
  
  #console.log "[" + tt + "] OK " + remote.address + ":" + remote.port + " - [" + message + "] awaiting [" + counter + "] latency ["+latency+"]"

  try
    jmessage = JSON.parse(message)
  catch err
    console.error("============Unable to parse=======\n"+message+"\n==============\n")
    return 
  
  
  from = jmessage.from
  recv = parseInt(jmessage.counter)
  nbErrorPacket = 0


  if !ilinkTimeout[from] 
    console.log "started new hitX for "+from
    ilinkTimeout[from] = {}
    ilinkTimeout[from].counter = 0
    ilinkTimeout[from].nextLatency = (new Date()).getTime()
    ilinkTimeout[from].nextHit = hitX(from,5)

  latency = tt-ilinkTimeout[from].nextLatency
  counter = ilinkTimeout[from].counter

  if recv isnt counter
    isOK = false;
    onWrongCounter(from,counter,recv)
    if recv < counter
      nbErrorPacket = 100-counter
      i = counter
      while i < 101
        ilinkTimeout[from][i] = ""
        i++
      i = 0
      nbErrorPacket+=recv
      while i < recv
        ilinkTimeout[from][i] = ""
        i++
    else
      i = counter
      while i < recv
        ilinkTimeout[from][i] = ""
        i++


  if latency >= expectedLatency
    isOK = false
    onLatency(from,counter,latency)
  
  if isOK 
    onMessage(from,counter,latency)
  

  if latency >= 0
    ilinkTimeout[from][recv] = latency
    ilinkTimeout[from].lastLatency = latency
  else
    ilinkTimeout[from][recv] = 0
    ilinkTimeout[from].lastLatency = 0

  #console.log ilinkTimeout[from]

  counter = recv + 1
  if counter > 100
    counter = 0

  ilinkTimeout[from].counter = counter

  ilinkTimeout[from].nextLatency = tt + 100



hitX = (from,value) ->
  console.log "Heartbeat "+from+" for timeout at "+value+" secondes."
  
  stats = storage[from];
  storage[from] = 1;
  if stats is null 
    console.log "ERROR "+stats
    stats = value*10
  
  
  #nbExpected = value*10
  #child = exec(config.latencyError + " " + from + " " +((nbExpected-stats)/nbExpected)*100 + " " + JSON.stringify(ilinkTimeout[from]), (error, stdout, stderr) ->
  #  sys.print (from + ' stdout: ' + stdout)
  #)

  nbExpected = value*10
  nbOk = stats
  if nbOk > nbExpected
    nbOk = nbExpected

  #console.log ("Got "+nbOk+" expected : "+nbExpected);

  to = config.from

  if config.MASTER_HOST
    sendToMaster(from,config.from,(nbOk/nbExpected)*100,ilinkTimeout[from].lastLatency,config.MASTER_HOST,config.MASTER_PORT)

  #cmd = "/bin/bash "+config.hitScript + " " + config.datastore + " " + from + " "+ to + " " + (nbOk/nbExpected)*100 + " " + ilinkTimeout[from].lastLatency
  #console.log ("running "+cmd)
  #child = exec(cmd, (error, stdout, stderr) ->
  #  if error
  #    console.error stderr
  #  sys.print (from + ' stdout: ' + stdout)
  #)


  # On repart pour un tour
  timeoutId = setTimeout (->
      hitX(from,value)
    ), (value*1000)+100;

  return timeoutId;



onMessage = (from,counter,expectedValue) -> 
  #console.log "Got hit ["+counter+"] I'm alive anyway.."
  storage[from] = 1  unless storage[from]
  stats5 = storage[from]
  stats5++;
  #console.log "Stats5 is " + stats5
  storage[from] = stats5


onWrongCounter = (from,counter,expectedValue) -> 
  console.log "["+from+"] Problem with counter ["+counter+"] Awaiting ["+expectedValue+"]"


onLatency = (from,counter,latency) ->
  console.log "["+from+"] Problem with latency counter ["+counter+"] latency is ["+latency+"]"
  

sendToMaster = (from, to, percentOK, latency, HOST,PORT)->
  message = new Buffer(JSON.stringify(
    from: from
    to: to
    percentOK: percentOK
    latency: latency
  ))
  
  client.send message, 0, message.length, PORT, HOST, (err, bytes) ->
    throw err  if err
    if verbose
      console.log "UDP message " + message + " sent to MASTER " + HOST + ":" + PORT


server.bind PORT, HOST
