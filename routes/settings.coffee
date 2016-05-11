express = require 'express'
mongo = require 'mongoskin'
redis = require 'redis'
router = express.Router()

# Redis Connect
client = redis.createClient()

# GET users listing.
router.get '/', (req, res) ->
  client.get "mail_settings", (err, reply) ->
    if reply
      reply = JSON.parse(reply)
    else
      reply = {}
    res.render 'settings',
      mail_settings: reply
      title: "Settings - Coffee alarm"

# POST settings smtp save
router.post '/smtp', (req, res) ->
  smtp_settings = "{
    \"smtp_server\": \"#{req.body.smtp_server}\",
    \"smtp_login\": \"#{req.body.smtp_username}\",
    \"smtp_password\": \"#{req.body.smtp_password}\",
    \"smtp_port\": \"#{req.body.smtp_port}\",
    \"sent_name\": \"#{req.body.sent_name}\"
  }"

  client.set("mail_settings", smtp_settings, redis.print);
  req.flash('success', '邮件配置已保存')
  res.redirect('back')

module.exports = router
