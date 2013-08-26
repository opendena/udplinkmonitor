config = require("./config")
dgram = require("dgram")
sys = require('sys')
exec = require('child_process').exec

PORT = config.MASTER_PORT or 33334

storage = {}
ilinkTimeout = {}

server = dgram.createSocket("udp4")
verbose = true;


server.on "listening", ->
  address = server.address()
  console.log "UDP MASTER Server listening on " + address.address + ":" + address.port


server.on "message", (message, remote) ->
  jmessage = JSON.parse(message)

  from = jmessage.from
  to = jmessage.to
  percentOK = parseInt(jmessage.percentOK)
  latency = parseInt(jmessage.latency)
  nbErrorPacket = 0

  cmd = config.hitScript + " " + config.datastore + " " + from + " "+ to + " " + percentOK + " " + latency
  console.log ("running "+cmd)
  child = exec(cmd, (error, stdout, stderr) ->
    if error
      console.error stderr
    #sys.print (from + ' stdout: ' + stdout)
  )

server.bind PORT, ""