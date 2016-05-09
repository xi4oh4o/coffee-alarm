express = require 'express'
redis = require('redis')
router = express.Router()

# GET users listing.
router.get '/', (req, res) ->
  client = redis.createClient()

  client.on 'error', (err) ->
    console.log('Error' + err)

  client.smembers 'groups', (err, replies) ->
    group_alias = {}
    for group in replies
      client.get 'alarm:group:alias:'+group, (err, reply) ->
        group_alias[group] = reply
        res.render 'groups',
          group_alias: group_alias
          groups: replies
          title: "Alarm"
        client.quit()

router.post '/', (req, res) ->
  client = redis.createClient()

  client.on 'error', (err) ->
    console.log('Error' + err)

  name = req.body.name
  cn_name = req.body.cn_name
  client.sadd 'groups', name, (err, replies) ->
    if replies == 1
      client.set 'alarm:group:alias:'+name, cn_name, (err, replies) ->
        req.flash('success', '群组创建成功')
        res.redirect('back')
    else
      req.flash('error', '群组已存在')
      res.redirect('back')
module.exports = router
