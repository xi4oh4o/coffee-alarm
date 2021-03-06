express = require 'express'
mongo = require 'mongoskin'
ensure_login = require 'connect-ensure-login'
router = express.Router()

# Mongodb Connect
require('dotenv').config()
db = mongo.db('mongodb://'+process.env.MONGO_HOST+':27017/alarm-doc')

# GET users listing.
router.get '/', ensure_login.ensureLoggedIn(), (req, res) ->
  db.collection('groups').find().toArray (err, result) ->
    if err
      throw err
    res.render 'groups',
      groups: result
      title: "Groups - Coffee alarm"

router.post '/', ensure_login.ensureLoggedIn(), (req, res) ->
  group_json = {
    "name": req.body.name,
    "cn_name": req.body.cn_name
  }
  db.collection('groups').insertOne group_json, (err, r) ->
    if r.insertedCount == 1
      req.flash('success', '群组创建成功')
      res.redirect('back')
    else
      req.flash('error', '群组已存在')
      res.redirect('back')
module.exports = router
