express = require 'express'
mongo = require 'mongoskin'
router = express.Router()

# Mongodb Connect
db = mongo.db('mongodb://localhost:27017/alarm-doc')

# GET users listing.
router.get '/', (req, res) ->
  res.render 'settings',
    title: "Settings - Coffee alarm"
module.exports = router
