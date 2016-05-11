kue = require 'kue'
mongo = require 'mongoskin'
nodemailer = require 'nodemailer'
queue = kue.createQueue()
require('dotenv').config();

# SMTP
smtp_server = process.env.SMTP_SERVER
smtp_login = process.env.SMTP_LOGIN
smtp_password = process.env.SMTP_PASSWORD

# Mongodb Connect
db = mongo.db('mongodb://localhost:27017/alarm-doc')

transporter = nodemailer.createTransport('smtps://'+encodeURIComponent(smtp_login)+':'+smtp_password+'@'+smtp_server)

email = (data, done) ->
  db.collection('users').find({"group":data.receive_group}).toArray (err, users) ->
    if err
      throw err
    for user in users
      done() if user?
      mailOptions = {
        "from": "Coffee alarm <postmaster@etude.mailgun.org>",
        "to": user.email,
        "subject": data.module + " 告警 等级 " + data.level
        "html" : data.message
      }
      transporter.sendMail mailOptions, (error, info) ->
        if error
          return console.log(error)
        db.collection('send_list').updateById data._id, {$set: {"sent":true}}, (err, result) ->
          console.log 'Message sent: ' + info.response
  done()
  return

queue.process 'email', 20, (job, done) ->
  email job.data, done
  return
