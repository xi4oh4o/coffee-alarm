express = require 'express'
redis = require('redis')
router = express.Router()

# GET users listing.
router.get '/', (req, res) ->
  client = redis.createClient()

  client.on 'error', (err) ->
    console.log('Error' + err)

  client.smembers 'groups', (err, replies) ->
    res.render 'groups',
      groups: replies
      title: "Alarm"
    client.quit()

router.post '/', (req, res) ->
  client = redis.createClient()

  client.on 'error', (err) ->
    console.log('Error' + err)
    
  name = req.body.name
  client.sadd 'groups', name, (err, replies) ->
    if replies == 1
      # @todo Flash Success
      res.redirect('back')
    else
      # @todo Flash Fail
      res.redirect('back')
module.exports = router
