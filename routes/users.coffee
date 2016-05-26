express = require 'express'
mongo = require 'mongoskin'
mongoosePaginator = require 'mongoose-paginator-simple'
queryString = require 'query-string'
ensure_login = require 'connect-ensure-login'
router = express.Router()

mongoose = require '../shared/mongoose'

# Mongodb Connect
require('dotenv').config();
skin_db = mongo.db('mongodb://'+process.env.MONGO_HOST+':27017/alarm-doc')
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', ->
  UserSchema = mongoose.Schema(
    name: String
    email: String
    phone: String
    group: String
  )

  UserSchema.plugin mongoosePaginator,
    maxLimit: 25
    convertCriteria: (criteria, schema) ->
      if criteria && criteria.name
        criteria.name = new RegExp(criteria.name, 'i')
      return criteria

  User = mongoose.model('User', UserSchema)

  # GET users listing.
  router.get '/', ensure_login.ensureLoggedIn(), (req, res) ->
    criteria = {}
    if req.query.name? and req.query.name != ""
      criteria['name'] = req.query.name
    if req.query.email? and req.query.email != ""
      criteria['email'] = req.query.email
    if req.query.group? and req.query.group != ""
      criteria['group'] = req.query.group
    if req.query.phone? and req.query.phone != ""
      criteria['phone'] = req.query.phone
    options =
      sort: datetime: '-1'
      page: parseInt(req.query.page)
      limit: if req.query.limit? then parseInt(req.query.limit) else 30

    User.paginate criteria, options, (err, users) ->
      throw err if err

      # Pagination helper
      isStart = () ->
        if users.page == 1 then return 'disabled'
      isEnd = () ->
        if (users.page * users.limit) > users.total-1 then return 'disabled'
      prevPage = () ->
        unless req.query.page? then req.query.page = 1
        req.query.page--
        return queryString.stringify(req.query)
      nextPage = () ->
        req.query.page+=2
        return queryString.stringify(req.query)

      skin_db.collection('groups').find().toArray (err, groups) ->
        throw err if err
        group_alias = {}
        for group in groups
          group_alias[group.name] = group.cn_name
        res.render 'users',
          users: users
          groups: groups
          group_alias: group_alias
          title: "People - Coffee Alarm"
          isStart: isStart
          isEnd: isEnd
          prevPage: prevPage
          nextPage: nextPage

router.post '/', ensure_login.ensureLoggedIn(), (req, res) ->
  users_json = {
    "name": req.body.name,
    "email": req.body.email,
    "phone": req.body.phone,
    "group": req.body.group
  }
  db.collection('users').insertOne users_json, (err, r) ->
    if r.insertedCount == 1
      req.flash('success', '人员创建成功')
      res.redirect('back')
    else
      req.flash('error', '人员已存在')
      res.redirect('back')

router.get '/delete/:id', ensure_login.ensureLoggedIn(), (req, res) ->
  db.collection('users').removeById req.params.id, (err, r) ->
    if r == 1
      req.flash('success', '人员删除成功')
      res.redirect('back')
    else
      req.flash('error', '人员删除失败')
      res.redirect('back')
module.exports = router
