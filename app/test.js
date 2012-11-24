var funcs = require('./funcs');

var gotIP = function(error, ip) {
 console.log("IP address is " + ip);
}

funcs.getNetworkIPs(gotIP, false);

var options = funcs.listLatestDownloads.options;
//funcs.listLatestDownloads.options.path = 'http://' + options.host + options.path;
//funcs.listLatestDownloads.options.host = 'wwwgate.ti.com';
funcs.listLatestDownloads();

var mdns = require('mdns');
var browser = mdns.createBrowser(mdns.tcp('ssh'));

browser.on('serviceUp', function(service) {
  console.log("service up: ", service);
});
browser.on('serviceDown', function(service) {
  console.log("service down: ", service);
});

browser.start();
