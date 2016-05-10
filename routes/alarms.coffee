express = require 'express'
mongo = require 'mongoskin'
router = express.Router()

# Mongodb Connect
db = mongo.db('mongodb://localhost:27017/alarm-doc')

# GET home page.
router.get '/', (req, res) ->
  db.collection('send_list').find().toArray (err, alarms) ->
    if err
      throw err
    res.render 'alarms',
      alarms: alarms
      title: "Alarms - Coffee alarm"

module.exports = router
