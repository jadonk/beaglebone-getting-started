var x = require('./index');

var gotIP = function(error, ip) {
 console.log("IP address is " + ip);
}

x.getNetworkIPs(gotIP, false);
