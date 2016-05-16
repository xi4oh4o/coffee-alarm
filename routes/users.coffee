express = require 'express'
mongo = require 'mongoskin'
ensure_login = require 'connect-ensure-login'
router = express.Router()

# Mongodb Connect
require('dotenv').config();
db = mongo.db('mongodb://'+process.env.MONGO_HOST+':27017/alarm-doc')

# GET users listing.
router.get '/', ensure_login.ensureLoggedIn(), (req, res, next) ->

  db.collection('users').find().toArray (err, users) ->
    if err
      throw err
    db.collection('groups').find().toArray (err, groups) ->
      if err
        throw err
      group_alias = {}
      for group in groups
        group_alias[group.name] = group.cn_name
      console.log(group_alias)
      res.render 'users',
        groups: groups
        users: users
        group_alias: group_alias
        title: "People - Coffee Alarm"

router.post '/', ensure_login.ensureLoggedIn(), (req, res) ->
  users_json = {
    "name": req.body.name,
    "email": req.body.email,
    "phone": req.body.phone,
    "group": req.body.group
  }
  db.collection('users').insertOne users_json, (err, r) ->
    if r.insertedCount == 1
      req.flash('success', '人员创建成功')
      res.redirect('back')
    else
      req.flash('error', '人员已存在')
      res.redirect('back')
module.exports = router
