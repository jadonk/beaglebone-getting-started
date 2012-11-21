var funcs = require('./funcs');

var gotIP = function(error, ip) {
 console.log("IP address is " + ip);
}

funcs.getNetworkIPs(gotIP, false);

var options = funcs.listLatestDownloads.options;
funcs.listLatestDownloads.options.path = 'http://' + options.host + options.path;
funcs.listLatestDownloads.options.host = 'wwwgate.ti.com';
funcs.listLatestDownloads();
