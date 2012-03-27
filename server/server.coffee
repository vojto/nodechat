hem = require('./hem')
socketio = require('socket.io')

http = hem.server()
socket = socketio.listen(http)

socket.sockets.on 'connection', (client) ->
  console.log 'client connected'
  client.on 'message', (message) ->
    socket.sockets.emit 'message', message
  client.on 'file', (file) ->
    console.log 'received file!', file
    socket.sockets.emit 'file', file