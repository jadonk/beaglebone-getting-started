var http = require('http');
var jsdom = require('jsdom');
var fs = require('fs');

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

var getLatestDownloads = function() {
 var mycall = function mycall(callback) {
  var responseHandler = function(res) {
   //console.log('STATUS: ' + res.statusCode);
   //console.log('HEADERS: ' + JSON.stringify(res.headers));
   res.setEncoding('utf8');
   var body = '';
   var dataHandler = function(chunk) {
    body = body + chunk;
   };
   var parseDownloads = function() {
    //console.log('Parsing...' + body);
    //console.log('Parsing...');
    var parser = function(err, window) {
     var $ = window.jQuery;
     var pd = function(i) {
      var downloadURL = $('a[itemprop="downloadURL"]').attr('href');
      console.log('downloadURL = ' + downloadURL);
      callback(downloadURL);
     };
     var downloads = $('li[itemtype="http://schema.org/SoftwareApplication"]').each(pd);
    };
    var options = {};
    options.html = body;
    options.src = fs.readFileSync("./jquery.js").toString();
    options.done = parser;
    jsdom.env(options);
   };
   res.on('data', dataHandler);
   res.on('end', parseDownloads);
  };
  //console.log('Making request: ' + JSON.stringify(mycall.options));
  var req = http.get(mycall.options, responseHandler);
  var errorHandler = function(e) {
   console.log('problem with request: ' + e.message);
  };
  req.on('error', errorHandler);
 };
 mycall.options = {};
 mycall.options.host = 'beagleboard.org';
 mycall.options.path = '/latest-images';
 mycall.options.port = 80;
 mycall.options.method = 'GET';

 return(mycall);
};

exports.getNetworkIPs = getNetworkIPs();
exports.getLatestDownloads = getLatestDownloads();
