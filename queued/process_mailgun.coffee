kue = require 'kue'
mongo = require 'mongoskin'
mailgun = require 'mailgun-js'
queue = kue.createQueue()
require('dotenv').config();

# Mailgun
api_key = process.env.MAILGUN_KEY
domain = process.env.MAILGUN_DOMAIN

# Mongodb Connect
db = mongo.db('mongodb://localhost:27017/alarm-doc')

mailgun = mailgun({"apiKey": api_key, "domain": domain})

email = (data, done) ->
  db.collection('users').find({"group":data.receive_group}).toArray (err, users) ->
    if err
      throw err
    for user in users
      done() if user?
      console.log process.env.MAILGUN_KEY
      mail = {
        "from": "Coffee alarm <postmaster@etude.mailgun.org>",
        "to": user.email,
        "subject": data.module + " 告警 等级 " + data.level
        "html" : data.message
      }
      mailgun.messages().send mail, (error, body) ->
        if error
          throw error
        db.collection('send_list').updateById data._id, {$set: {"sent":true}}, (err, result) ->
          console.log(result)
  done()
  return

queue.process 'email', 20, (job, done) ->
  email job.data, done
  return
