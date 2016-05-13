#!/usr/bin/env coffee
mongo = require 'mongoskin'

username = process.argv[2]
password = process.argv[3]

user_json =
  username: process.argv[2]
  password: process.argv[3]

db = mongo.db('mongodb://localhost:27017/alarm-doc')

db.collection('manager').insertOne user_json, (err, r) ->
  if r.insertedCount == 1
    console.log "登录帐号创建成功\n"
    console.log "用户名："+user_json.username
    console.log "密码: "+user_json.password
    console.log "\n 请执行Ctrl+C 结束"
