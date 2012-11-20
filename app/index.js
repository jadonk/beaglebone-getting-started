loadSocketIO = function(ip) {
 var url = 'http://' + ip[0] + ':3000/';
 var socketIOURL = url + 'socket.io/socket.io.js';
 console.log('URL is ' + socketIOURL);
 var socketIOLoaded = function(script, textStatus, jqXHR) {
  var socket = io.connect(url);
  var connected = function() {
   $('#socket_status').html('Connected to ' + url);
  };
  var connecting = function() {
   $('#socket_status').html('Connecting to ' + url);
  };
  var disconnected = function() {
   $('#socket_status').html('Disconnected');
  };
  var connectFailed = function() {
   $('#socket_status').html('Connection to ' + url + ' failed');
  };
  var reconnecting = function() {
   $('#socket_status').html('Reconnecting to ' + url);
  };
  var reconnect = function() {
   $('#socket_status').html('Reconnected to ' + url);
  };
  socket.on('connect', connected);
  socket.on('connecting', connecting);
  socket.on('disconnect', disconnected);
  socket.on('connect_failed', connectFailed);
  socket.on('reconnect', reconnect);
  socket.on('reconnecting', reconnecting);
 };

 jQuery.getScript(socketIOURL, socketIOLoaded);
};

var gotIP = function(error, ip) {
 loadSocketIO(ip);
};

var myInit = function() {
 gotIP(null, ['127.0.0.1']);
};

myInit();
