express = require 'express'
mongo = require 'mongoskin'
kue = require 'kue'
router = express.Router()

# Mongodb Connect
db = mongo.db('mongodb://localhost:27017/alarm-doc')

# Kue Quened
queue = kue.createQueue()

router.get '/receiver', (req, res) ->
  json_ret = {
    "code": 1002,
    "msg": "BAD REQUEST",
    "request": req.route.path
  }
  res.status(400).json(json_ret)

router.post '/receiver', (req, res) ->
  db.collection('send_list').insertOne req.body, (err, r) ->
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
