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

exports.getNetworkIPs = getNetworkIPs;
