express = require 'express'
ensure_login = require 'connect-ensure-login'
router = express.Router()

# GET home page.
router.get '/', ensure_login.ensureLoggedIn(), (req, res, next) ->
  res.render 'index',
    title: 'Coffee alarm'

module.exports = router
