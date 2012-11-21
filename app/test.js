var funcs = require('./funcs');

var gotIP = function(error, ip) {
 console.log("IP address is " + ip);
}

funcs.getNetworkIPs(gotIP, false);

funcs.listLatestDownloads.options.host = 'wwwgate.ti.com';
funcs.listLatestDownloads.options.path = 'http://beagleboard.org/latest-images/';
funcs.listLatestDownloads();
