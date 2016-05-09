express = require 'express'
redis = require('redis')
router = express.Router()

# GET users listing.
router.get '/', (req, res, next) ->
  client = redis.createClient()

  client.on 'error', (err) ->
    console.log('Error' + err)

  client.smembers 'groups', (err, replies) ->
    res.render 'users',
      groups: replies
      title: "人员 - Coffee Alarm"
    client.quit()

module.exports = router
