express = require 'express'
mongoose = require 'mongoose'
router = express.Router()


# GET home page.
router.get '/', (req, res) ->
  mongoose.connect('mongodb://localhost/alarm-doc')
  db = mongoose.connection
  db.on 'error', console.error.bind(console, 'connection error:')
  db.once 'open', ->
    ListSchema = mongoose.Schema(
      receive_group: String
      level: String
      module: String
      message: String
      sms_notice: Boolean
      sent: Boolean
    )

    List = mongoose.model('List', ListSchema)
    List.find (err, lists) ->
      throw err if err
      res.render 'alarms',
      alarms: lists
      title: "Alarms - Coffee alarm"

module.exports = router
