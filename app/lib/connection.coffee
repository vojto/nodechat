Aes = require('../vendor/aes')

class Connection
  password: "MegaSecretKey"
  
  constructor: (options) ->
    @delegate = options.delegate
    @socket   = options.socket
    @mode     = options.mode

    if @mode == 'server'
      @initServer(@socket) if @mode == 'server'
    else
      @initClient(@socket)
  
  initServer: (socket) ->
    console.log 'initializing server'
    socket.sockets.on 'connection', (client) =>
      @initClient(client)
    
  initClient: (socket) ->
    console.log 'initializing client'
    socket.on 'message', @didReceiveMessage
    socket.on 'file', @didReceiveFile
  
  sendFile: (object) ->
    @send('file', object)
    
  sendMessage: (object) ->
    @send('message', object)
  
  send: (type, object) ->
    data = @encryptObject(object)
    
    if @mode == "server"
      @socket.sockets.emit type, data
    else
      @socket.emit type, data
  
  encryptObject: (object) ->
    @encryptData(JSON.stringify(object))
  
  encryptData: (data) ->
    Aes.Ctr.encrypt(data, @password, 256)
  
  decryptObject: (encrypted) ->
    data = Aes.Ctr.decrypt(encrypted, @password, 256)
    JSON.parse(data)
  
  didReceiveMessage: (data) =>
    console.log 'received msg', data
    object = @decryptObject(data)
    @delegate.didReceiveMessage(object)
    
  didReceiveFile: (data) =>
    object = @decryptObject(data)
    @delegate.didReceiveFile(object)

module.exports = Connection