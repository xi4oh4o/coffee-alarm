express = require 'express'
mongo = require 'mongoskin'
router = express.Router()

# Mongodb Connect
db = mongo.db('mongodb://localhost:27017/alarm-doc')

# GET users listing.
router.get '/', (req, res, next) ->
  db.collection('groups').find().toArray (err, result) ->
    if err
      throw err
    res.render 'users',
      groups: result
      title: "People - Coffee Alarm"

module.exports = router
