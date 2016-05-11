kue = require 'kue'
mongo = require 'mongoskin'
nodemailer = require 'nodemailer'
redis = require 'redis'
queue = kue.createQueue()
client = redis.createClient()

# Mongodb Connect
db = mongo.db('mongodb://localhost:27017/alarm-doc')

email = (data, done) ->

  # Load SMTP Settings
  client.get "mail_settings", (err, reply) ->
    if reply
      config = JSON.parse(reply)
    else
      console.log 'SMTP configure not found'
      return
    # Build nodemailer transporter
    transporter = nodemailer.createTransport('smtps://'+encodeURIComponent(config.smtp_login)+':'+config.smtp_password+'@'+config.smtp_server)

    # According to the receive group send to mail
    db.collection('users').find({"group":data.receive_group}).toArray (err, users) ->
      if err
        throw err
      for user in users
        return console.log 'User Not Found' unless user?

        # Build mail
        mailOptions = {
          "from": config.sent_name+" <"+config.smtp_login+">",
          "to": user.email,
          "subject": data.module + " 告警 等级 " + data.level
          "html" : data.message
        }
        # Sent Mail & Update List status
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
