var express = require('express');
var http = require('http');
var app = express();

var helloworld = function(req, res) {
 var body = 'Hello World';
 res.setHeader('Content-Type', 'text/plain');
 res.setHeader('Content-Length', body.length);
 res.end(body);
};

var configure = function() {
 app.set('port', process.env.PORT || 3000);
 app.use(express.logger('dev'));
};

var log = function() {
 console.log("Express server listening on port " + app.get('port'));
};

app.configure(configure);
app.get('/hello.txt', helloworld);
http.createServer(app).listen(app.get('port'), log);
