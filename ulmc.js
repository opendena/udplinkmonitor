var PORT = 33333;
var HOST = '';

var dgram = require('dgram');
var counter = 0;
var message = new Buffer(''+counter);

var client = dgram.createSocket('udp4');


function sendPacket(){

var message = new Buffer(''+counter);
counter++;
client.send(message, 0, message.length, PORT, HOST, function(err, bytes) {
    if (err) throw err;
    console.log('UDP message '+message+' sent to ' + HOST +':'+ PORT);
});
setTimeout(sendPacket,100);
}


sendPacket();
