var http = require('http');
var socketio = require('socket.io')

var io = socketio.listen(process.env.PORT || 3000);

io.sockets.on('connection', function (socket) {
  socket.emit('news', { hello: 'world' });
  socket.on('my other event', function (data) {
    console.log(data);
  });
});

