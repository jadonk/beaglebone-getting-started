console.log('Starting app.js');

try {
 var http = require('http');
 var socketio = require('socket.io');
 var mdns = require('mdns');
 var funcs = require('./funcs');

 var socketConnect = function(socket) {
  var mdnsServiceUp = function(service) {
   socket.emit('serviceUp', service);
  };
  var mdnsServiceDown = function(service) {
   socket.emit('serviceDown', service);
  };
  var mdnsError = function(error) {
   console.log('mdns error: ' + error);
  };
  mdns.createBrowser(mdns.tcp('ssh'))
   .on('serviceUp', mdnsServiceUp)
   .on('serviceDown', mdnsServiceDown)
   .on('error', mdnsError)
   .start();
  mdns.createBrowser(mdns.tcp('http'))
   .on('serviceUp', mdnsServiceUp)
   .on('serviceDown', mdnsServiceDown)
   .on('error', mdnsError)
   .start();
  mdns.createBrowser(mdns.tcp('https'))
   .on('serviceUp', mdnsServiceUp)
   .on('serviceDown', mdnsServiceDown)
   .on('error', mdnsError)
   .start();
 };

 var socketConnect = function(socket) {
  var sendIPs = function(data) {
   socket.emit('myIP', data);
  };
  funcs.getNetworkIPs(sendIPs, false);

  var sendLatestDownloads = function(data) {
   socket.emit('latestDownloads', data);
  };  
  funcs.getLatestDownloads(sendLatestDownloads);

  var mdnsServiceUp = function(service) {
   socket.emit('serviceUp', service);
  };
  var mdnsServiceDown = function(service) {
   socket.emit('serviceDown', service);
  };
  var mdnsError = function(error) {
   console.log('mdns error: ' + error);
  };
  mdns.createBrowser(mdns.tcp('ssh'))
   .on('serviceUp', mdnsServiceUp)
   .on('serviceDown', mdnsServiceDown)
   .on('error', mdnsError)
   .start();
  mdns.createBrowser(mdns.tcp('http'))
   .on('serviceUp', mdnsServiceUp)
   .on('serviceDown', mdnsServiceDown)
   .on('error', mdnsError)
   .start();
  mdns.createBrowser(mdns.tcp('https'))
   .on('serviceUp', mdnsServiceUp)
   .on('serviceDown', mdnsServiceDown)
   .on('error', mdnsError)
   .start();
 };

 var io = socketio.listen(process.env.PORT || 3000);
 //var io = socketio.listen(3000);
 io.sockets.on('connection', socketConnect);
} catch(ex) {
 console.log('Exception = ' + ex);
}


