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

express = require("express")
app = express()

app.configure ->
  app.use "/datas",express.static(config.datastore)
  app.use "/datas",express.directory(config.datastore)
  app.use express.errorHandler()

app.get "/", (req, res) ->
    cmd = "/bin/bash " + __dirname+"/bin/graphAll.sh "+config.datastore
    console.log ("running "+cmd)
    child = exec(cmd, (error, stdout, stderr) ->
        if error
          res.send stderr
        else
          res.redirect "/datas/index.html"
    )  

app.listen 3000
