Spine = require('spine')

class Message extends Spine.Model
  @configure 'Message', 'message', 'username', 'name', 'url', 'type'

module.exports = Message