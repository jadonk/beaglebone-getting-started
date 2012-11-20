var http = require('http');

var getNetworkIPs = function () {
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

 var mycall = function(callback, bypassCache) {
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

 return(mycall);
};

var listLatestDownloads = function() {
 var options = {
  host: 'beagleboard.org'
  , port: 80
  , path: '/latest-images/'
  , method: 'GET'
 };
 var responseHandler = function(res) {
  console.log('STATUS: ' + res.statusCode);
  console.log('HEADERS: ' + JSON.stringify(res.headers));
  res.setEncoding('utf8');
  var dataHandler = function(chunk) {
   console.log('BODY: ' + chunk);
  };
  res.on('data', dataHandler);
 };
 var mycall = function() {
  var req = http.request(options, responseHandler);
  var errorHandler = function(e) {
   console.log('problem with request: ' + e.message);
  };
  req.on('error', errorHandler);
  req.end();
 };

 return(mycall);
};

exports.getNetworkIPs = getNetworkIPs();
exports.listLatestDownloads = listLatestDownloads();
