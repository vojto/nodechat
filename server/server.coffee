Hem       = require('./hem')
fs        = require('fs')
Aes       = require('../app/vendor/aes')
SocketIO  = require('socket.io')

Connection  = require('../app/lib/connection')

class Server  
  constructor: ->
    @http        = Hem.server()
    @socket      = SocketIO.listen(@http)
    @connection  = new Connection(mode: 'server', delegate: @, socket: @socket)
  
  didReceiveMessage: (object) ->
    console.log "server received message:", object
    @connection.sendMessage(object)
  
  didReceiveFile: (object) ->
    console.log "server received file", object

    fs.writeFile "#{__dirname}/../public/files/#{object.name}", object.data, "utf8", (err) =>
      info = {name: object.name, url: "/files/#{object.name}", username: object.username}
      @connection.sendFile(info)
    

server      = new Server