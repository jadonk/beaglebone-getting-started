var http = require('http');
var socketio = require('socket.io');
var mdns = require('mdns');
var funcs = require('./funcs');

//var io = socketio.listen(process.env.PORT || 3000);
var io = socketio.listen(3000);

var socketConnect = function(socket) {
 var mdnsServiceUp = function(service) {
  socket.emit('serviceUp', service);
 };
 var mdnsServiceDown = function(service) {
  socket.emit('serviceDown', service);
 };
 mdns.createBrowser(mdns.tcp('ssh'))
  .on('serviceUp', mdnsServiceUp)
  .on('serviceDown', mdnsServiceDown)
  .start();
 mdns.createBrowser(mdns.tcp('http'))
  .on('serviceUp', mdnsServiceUp)
  .on('serviceDown', mdnsServiceDown)
  .start();
 mdns.createBrowser(mdns.tcp('https'))
  .on('serviceUp', mdnsServiceUp)
  .on('serviceDown', mdnsServiceDown)
  .start();
};
io.sockets.on('connection', socketConnect);

