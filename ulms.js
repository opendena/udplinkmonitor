var PORT = 33333;
var HOST = '';

var dgram = require('dgram');
var server = dgram.createSocket('udp4');

var counter = 0;
var nextt = (new Date()).getTime();

server.on('listening', function () {
    var address = server.address();
    console.log('UDP Server listening on ' + address.address + ":" + address.port);
});

server.on('message', function (message, remote) {
    var tt = (new Date()).getTime();
    console.log('['+tt+'] '+ remote.address + ':' + remote.port +' - [' + message+'] awaiting ['+counter+']');
    var recv = parseInt(message);
    if ( ( (tt-nextt) >= 10 ) ||  ( recv != counter ) ){
        console.log('Problem ['+(tt - nextt)+'] ['+recv+'/'+counter+']');
    }
    counter = parseInt(message)+1;
    nextt = tt+100;
});

server.bind(PORT, HOST);
