require('lib/setup')

Spine = require('spine')
Kit   = require('appkit')
IO = require('vendor/socket.io')
Aes = require('vendor/aes')

Connection = require('lib/connection')

Message = require('models/message')
window.Message = Message

MessageView = require('views/message')
    

class App extends Spine.Controller
  constructor: ->
    super
    @setupViews()
    @socket = IO.connect('http://localhost')
    @connection = new Connection(delegate: @, socket: @socket)
  
  setupViews: ->
    @name = prompt("Name?")
    @form = new Kit.Form(fields: {message: 'Message'}, delegate: this)
    @list = new Kit.List(model: Message, method: 'message', delegate: @, itemView: MessageView)
    @append @list, @form
    @fileField = $("<input type='file' />")
    @fileField.change(@didSelectFile)
    @form.el.append(@fileField)
  
  didSelectFile: =>
    files = @fileField.get(0).files
    return if files.length == 0
    file = files[0]
    
    reader = new FileReader()
    reader.onload = (e) =>
      data = e.target.result
      @connection.sendFile({data: data, name: file.fileName, username: @name})
    reader.readAsText(file)
  
  didReceiveMessage: (message) =>
    message = new Message(message)
    message.type = 'text'
    message.save()
    @update()
  
  didReceiveFile: (file) =>
    console.log 'got file', file
    message = new Message(file)
    message.type = 'file'
    message.save()
    @update()
  
  update: ->
    $("body").prop(scrollTop: 9999)
  
  didSubmit: (object) ->
    object.username = @name
    @connection.sendMessage(object)
    @form.reset()
  
  didSelect: ->
    

module.exports = App