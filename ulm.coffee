config = require("./config")
dgram = require("dgram")

client = require("./ulmc")
server = require("./ulms")

for i of config.servers
  client.start(config.from,config.servers[i] ,33333)
  
console.log ("Started")