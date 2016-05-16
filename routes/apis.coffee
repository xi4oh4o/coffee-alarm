express = require 'express'
mongo = require 'mongoskin'
kue = require 'kue'
router = express.Router()

# Mongodb Connect
require('dotenv').config()
db = mongo.db('mongodb://'+process.env.MONGO_HOST+':27017/alarm-doc')

# Kue Quened
queue = kue.createQueue()

router.get '/receiver', (req, res) ->
  json_ret = {
    "code": 1002,
    "msg": "BAD REQUEST",
    "request": req.route.path
  }
  res.status(400).json(json_ret)

###
@api {post} /api/receiver 通知告警平台
@apiVersion 0.0.1
@apiName 通知告警平台
@apiGroup apis

@apiParamExample {json} 请求例:
{
    "receive_group": "dev",
    "level": "warning",
    "module": "服务器告警",
    "message": "<b>服务器猛烈燃烧!!!</b>",
    "sms_notice": true
    "datetime": "2016-01-18 06:56:10"
}
@apiParam  {String} receive_group 收件群组
@apiParam  {String} level 告警级别
@apiParam  {String} module 告警模块
@apiParam  {String} message 告警内容支持HTML
@apiParam  {Boolean} sms_notice 是否发送SMS通知

@apiParamExample {json} 请求成功返回值例:
{
  "code": 1000,
  "msg": "CREATED job:7",
  "request": "/receiver"
}

@apiParamExample {json} 请求失败返回值例:
{
  "code": 999,
  "msg": "INTERNAL SERVER ERROR",
  "request": req.route.path
}
###
router.post '/receiver', (req, res) ->
  db.collection('lists').insertOne req.body, (err, r) ->
    if r.insertedCount == 1
      job = queue.create('email', req.body).save((err) ->
        if !err
          res.status(201).json({
            "code": 1000,
            "msg": "CREATED job:"+ job.id,
            "request": req.route.path
          })
        else
          res.status(500).json({
            "code": 1001,
            "msg": "CREATED job fail",
            "request": req.route.path
          })
      )
    else
      res.status(500).json({
        "code": 999,
        "msg": "INTERNAL SERVER ERROR",
        "request": req.route.path
        })
module.exports = router
