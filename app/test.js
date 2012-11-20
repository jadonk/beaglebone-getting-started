require('./index');

var gotIP = function(error, ip) {
 console.log("IP address is " + ip);
}

getNetworkIPs(gotIP, false);

var mydocument = {};
mydocument.write = function(text) {
 console.log("document.write = " + text);
};
mydocument.createElement = function(element) {
 console.log("document.createElement = " + element);
 return({});
};
mydocument.getElementsByTagName = function(name) {
 var x = {};
 x.addEventListener = function(a, b, c) {
  console.log("addEventListener = " + [a, b, c]);
 };
 x.parentNode = {};
 x.parentNode.insertBefore = function(a, b) {
  console.log("parentNode.insertBefore = " + [a, b]);
 };
 console.log("document.getElementsByTagName = " + name);
 return([x]);
};

writeIP(mydocument);

var loadSocketIOForIP = function(error, ip) {
 loadSocketIO(mydocument, ip);
};

getNetworkIPs(loadSocketIOForIP, false);
