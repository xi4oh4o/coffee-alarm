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
      req.flash('success', '群组创建成功')
      res.redirect('back')
    else
      req.flash('error', '群组已存在')
      res.redirect('back')
module.exports = router
