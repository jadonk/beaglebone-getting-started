var toID = function(string) {
 var id = string.replace(/[^A-Za-z0-9]*/g, '');
 return id;
};

var loadSocketIO = function(ip) {
 var url = 'http://' + ip[0] + ':3000/';
 var socketIOURL = url + 'socket.io/socket.io.js';
 console.log('URL is ' + socketIOURL);
 var socketIOLoaded = function(script, textStatus, jqXHR) {
  var socket = io.connect(url);
  var connected = function() {
   $('#socket_status').html('Connected to ' + url);
  };
  socket.on('connect', connected);
  var connecting = function() {
   $('#socket_status').html('Connecting to ' + url);
  };
  socket.on('connecting', connecting);
  var disconnected = function() {
   $('#socket_status').html('Disconnected');
  };
  socket.on('disconnect', disconnected);
  var connectFailed = function() {
   $('#socket_status').html('Connection to ' + url + ' failed');
  };
  socket.on('connect_failed', connectFailed);
  var reconnecting = function() {
   $('#socket_status').html('Reconnecting to ' + url);
  };
  socket.on('reconnect', reconnect);
  var reconnect = function() {
   $('#socket_status').html('Reconnected to ' + url);
  };
  socket.on('reconnecting', reconnecting);
  var serviceUp = function(service) {
   if($('#' + toID(service.fullname)).length == 0) {
    $('#services').append('<li id="' + toID(service.fullname) +
     '"><a href="' + 
     service.type.name + '://' +
     service.addresses[0] +
     ':' + service.port +
     '/">' + service.name +
     '</a></li>\n'
    );
   }
  }
  socket.on('serviceUp', serviceUp);
  var serviceDown = function(service) {
   var item = $('#' + toID(service.fullname));
   if(item.length != 0) {
    item.remove();
   }
  };
  socket.on('serviceDown', serviceDown);
 };

 jQuery.getScript(socketIOURL, socketIOLoaded);
};

loadSocketIO(['127.0.0.1']);
