express = require 'express'
mongoosePaginator = require 'mongoose-paginator-simple'
queryString = require 'query-string'
mongo = require 'mongoskin'
ensure_login = require 'connect-ensure-login'
router = express.Router()

mongoose = require '../shared/mongoose'

require('dotenv').config()
skin_db = mongo.db('mongodb://'+process.env.MONGO_HOST+':27017/alarm-doc')

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', ->
  ListSchema = mongoose.Schema(
    receive_group: String
    level: String
    module: String
    message: String
    sms_notice: Boolean
    sent: Boolean
    datetime: String
  )

  ListSchema.plugin mongoosePaginator,
    maxLimit: 25

  List = mongoose.model('List', ListSchema)
  router.get '/', ensure_login.ensureLoggedIn(), (req, res) ->
    criteria = {}
    if req.query.level? and req.query.level != ""
      criteria['level'] = req.query.level
    if req.query.group? and req.query.group != ""
      criteria['receive_group'] = req.query.group
    if req.query.datetime? and req.query.datetime != ""
      criteria['datetime'] = req.query.datetime

    options =
      sort: datetime: '-1'
      page: parseInt(req.query.page)
      limit: if req.query.limit? then parseInt(req.query.limit) else 30

    List.paginate criteria, options, (err, lists) ->
      throw err if err

      # Pagination helper
      isStart = () ->
        if lists.page == 1 then return 'disabled'
      isEnd = () ->
        if (lists.page * lists.limit) > lists.total-1 then return 'disabled'
      prevPage = () ->
        unless req.query.page? then req.query.page = 1
        req.query.page--
        return queryString.stringify(req.query)
      nextPage = () ->
        req.query.page+=2
        return queryString.stringify(req.query)
      skin_db.collection('groups').find().toArray (err, groups) ->
        if err
          throw err
        group_alias = {}
        res.render 'alarms',
        alarms: lists
        isStart: isStart
        isEnd: isEnd
        prevPage: prevPage
        nextPage: nextPage
        groups: groups
        title: "Alarms - Coffee alarm"

module.exports = router
