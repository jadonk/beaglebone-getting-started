var funcs = require('./funcs');

var gotIP = function(error, ip) {
 console.log("IP address is " + ip);
}

funcs.getNetworkIPs(gotIP, false);
