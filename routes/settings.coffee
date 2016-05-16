express = require 'express'
mongo = require 'mongoskin'
redis = require 'redis'
ensure_login = require 'connect-ensure-login'
router = express.Router()

require('dotenv').config()
# Redis Connect
client = redis.createClient(process.env.REDIS_PORT, process.env.REDIS_HOST)

# GET users listing.
router.get '/', ensure_login.ensureLoggedIn(), (req, res) ->
  client.get "mail_settings", (err, reply) ->
    if reply
      reply = JSON.parse(reply)
    else
      reply = {}
    res.render 'settings',
      mail_settings: reply
      title: "Settings - Coffee alarm"

# POST settings smtp save
router.post '/smtp', ensure_login.ensureLoggedIn(), (req, res) ->
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
