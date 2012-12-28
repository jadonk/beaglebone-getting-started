var port = process.env.PORT || 3000;

var toID = function(string) {
 var id = string.replace(/[^A-Za-z0-9]*/g, '');
 return id;
};

var chooseIP = function(ip) {
 for(n in ip) {
  if(ip[n].match(/\:/)) {
   return(ip[n]);
  }
 }
 return(ip[0]);
};

var loadSocketIO = function(ip) {
 try {
  var url = 'http://' + ip[0] + ':' + port + '/';
  var socketIOURL = url + 'socket.io/socket.io.js';
  console.log('URL is ' + socketIOURL);
  var socketIOLoaded = function(script, textStatus, jqXHR) {
   var socket = io.connect(url);
   var onDisconnect = function() {
    var remove = function() {
     $(this).remove();
    };
    $('#services li').each(remove);
   };
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
    onDisconnect();
   };
   socket.on('disconnect', disconnected);
   var connectFailed = function() {
    $('#socket_status').html('Connection to ' + url + ' failed');
   };
   socket.on('connect_failed', connectFailed);
   var reconnecting = function() {
    $('#socket_status').html('Reconnecting to ' + url);
    onDisconnect();
   };
   socket.on('reconnect', reconnect);
   var reconnect = function() {
    $('#socket_status').html('Reconnected to ' + url);
   };
   socket.on('reconnecting', reconnecting);
   var serviceUp = function(service) {
    var username = '';
    if($('#' + toID(service.fullname)).length == 0) {
     if((service.type.name == 'ssh') && (service.host.match(/beagle/))) {
      username = 'root@';
     }
     $('#services').append('<li id="' + toID(service.fullname) +
      '"><a href="' + 
      service.type.name + '://' +
      username + service.addresses[0] +
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

   var myIP = function(data) {
   };
   socket.on('myIP', myIP);

   var latestDownloads = function(data) {
    $('#downloads').append('<li>' + data + '</li>');
   };
   socket.on('latestDownloads', latestDownloads);
  };
 
  jQuery.getScript(socketIOURL, socketIOLoaded);
 } catch(ex) {
  $('#socket_status').html('Exception: ' + ex);
 }
};

loadSocketIO(['127.0.0.1']);
