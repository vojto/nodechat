require('lib/setup')

io = require('vendor/socket.io')

Spine = require('spine')
Kit   = require('appkit')

Message = require('models/message')
window.Message = Message

MessageView = require('views/message')

class App extends Spine.Controller
  constructor: ->
    super
    @setupViews()
    @setupNetwork()
  
  setupViews: ->
    @name = prompt("Ako sa volas?")
    @form = new Kit.Form(fields: {message: 'Message'}, delegate: this)
    @list = new Kit.List(model: Message, method: 'message', delegate: @, itemView: MessageView)
    @append @list, @form
  
  setupNetwork: ->
    @socket = io.connect('http://localhost')
    @socket.on 'message', @didReceiveMessage
  
  didReceiveMessage: (message) =>
    message = new Message(message)
    message.save()
    @form.reset()
  
  didSubmit: (object) ->
    object.name = @name
    @socket.emit('message', object)
    

module.exports = App