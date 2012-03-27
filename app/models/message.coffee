Spine = require('spine')

class Message extends Spine.Model
  @configure 'Message', 'message', 'name'

module.exports = Message