# Dependency
express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
session = require 'express-session'
flash = require 'connect-flash'
bodyParser = require 'body-parser'
coffee = require 'express-coffee-script'
passport = require('passport')
Strategy = require('passport-local').Strategy
mongo = require 'mongoskin'

db = mongo.db('mongodb://localhost:27017/alarm-doc')

passport.use new Strategy((username, password, cb) ->
  db.collection('manager').find({"username": username}).toArray (err, user) ->
    if err
      return cb(err)
    if !user[0]
      return cb(null, false, message: '无效的用户名 ' + username)
    if user[0].password != password
      return cb(null, false, message: '无效的密码')
    cb null, user[0]
)

passport.serializeUser (user, cb) ->
  cb null, user._id
  return
passport.deserializeUser (id, cb) ->
  db.collection('manager').find({"_id": id}).toArray (err, user) ->
    if err
      return cb(err)
    cb null, user
    return
  return

# Load dotenv
require('dotenv').config();

# Router Middleware
routes = require './routes/index'
alarms = require './routes/alarms'
users = require './routes/users'
groups = require './routes/groups'
settings = require './routes/settings'
apis = require './routes/apis'

# Initialize express app
app = express()

# Set Cookie & Sessions
app.use logger 'combined'
app.use cookieParser 'keyboard cat'
app.use session({
  cookie: maxAge: 60000
  resave: false
  saveUninitialized: false
  secret: process.env.SESSION_SECRET
})

app.use(passport.initialize());
app.use(passport.session());

# Use Flash Messages
app.use flash()
app.use (req, res, next) ->
  res.locals.messages = require('express-messages')(req, res);
  next();

# view engine setup
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'pug'

# uncomment after placing your favicon in /public
# app.use favicon "#{__dirname}/public/favicon.ico"
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded
  extended: false

# Set static file
app.use express.static path.join __dirname, 'public'

# CoffeeScript Support
app.use coffee(
  src: 'public/coffee'
  dest: 'public/javascripts'
  prefix: '/javascripts'
  compilerOpts: bare: true
)

app.get '/login', (req, res) ->
  res.render 'login',
    title: 'Login'

app.post '/login', passport.authenticate('local',
  successReturnToOrRedirect: '/'
  failureRedirect: '/login'
  failureFlash: true)

# Use Router Middleware
app.use '/', routes
app.use '/alarms', alarms
app.use '/users', users
app.use '/groups', groups
app.use '/settings', settings
app.use '/api', apis

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

# error handlers

# development error handler
# will print stacktrace
if app.get('env') is 'development'
    app.use (err, req, res, next) ->
        res.status err.status or 500
        res.render 'error',
            message: err.message,
            error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
        message: err.message,
        error: {}

module.exports = app
