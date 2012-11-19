var getNetworkIPs = (function () {
 var ignoreRE = /^(127\.0\.0\.1|::1|fe80(:1)?::1(%.*)?)$/i;

 var exec = require('child_process').exec;
 var cached;
 var command;
 var filterRE;

 switch (process.platform) {
 case 'win32':
 case 'win64':
  command = 'ipconfig';
  filterRE = /\bIP(v[46])?-?[^:\r\n]+:\s*([^\s]+)/g;
  break;
 case 'darwin':
  command = 'ifconfig';
  filterRE = /\binet\s+([^\s]+)/g;
  break;
 default:
  command = 'ifconfig';
  filterRE = /\binet\b[^:]+:\s*([^\s]+)/g;
  break;
 }

 return function (callback, bypassCache) {
  if (cached && !bypassCache) {
   callback(null, cached);
   return;
  }
  // system call
  exec(command, function (error, stdout, sterr) {
   cached = [];
   var ip;
   var matches = stdout.match(filterRE) || [];
   for (var i = 0; i < matches.length; i++) {
    ip = matches[i].replace(filterRE, '$1')
    if (!ignoreRE.test(ip)) {
     cached.push(ip);
    }
   }
   callback(error, cached);
  });
 };
})();

var loadScript = function(document, script, callback) {
 var s = document.createElement('script');
 s.type = 'text/javascript';
 s.async = true;
 s.src = script;
 var x = document.getElementsByTagName('script')[0];
 //o.u = '//' + script;
 if (callback) {
  var listener = function(e) {
   callback(null, e);
  };
  x.addEventListener('load', listener, false);
 }
 x.parentNode.insertBefore(s, x);
};

loadSocketIO = function(error, ip) {
 console.log('http://' + ip + '/socket.io/socket.io.js');
 var socketIOLoaded = function(error, e) {
  var socket = io.connect('http://' + ip + ':3000/');
  var connected = function() {
   alert("Connected to " + ip);
  };
  socket.on('connect', connected);
 };

 loadScript('http://' + ip + ':3000/socket.io/socket.io.js', socketIOLoaded);
};

var writeIP = function(document) {
 getNetworkIPs(
  function(error, ip) {
   document.write("" + ip);
  }
  , false
 );
};

exports.loadScript = loadScript;
exports.writeIP = writeIP;
exports.getNetworkIPs = getNetworkIPs;
exports.loadSocketIO = loadSocketIO;
