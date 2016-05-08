express = require 'express'
redis = require('redis')
router = express.Router()

# GET users listing.
router.get '/', (req, res, next) ->
  client = redis.createClient()

  client.on 'error', (err) ->
    console.log('Error' + err)

  client.smembers 'groups', (err, replies) ->
    res.render 'groups',
      groups: replies
      title: "Alarm"
    return

module.exports = router
