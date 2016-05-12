express = require 'express'
mongoosePaginator = require 'mongoose-paginator-simple'
queryString = require 'query-string'
router = express.Router()
mongoose = require '../shared/mongoose'

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
  router.get '/', (req, res) ->
    criteria = {}
    if req.query.level? then criteria['level'] = req.query.level
    if req.query.group? then criteria['receive_group'] = req.query.group

    options =
      page: parseInt(req.query.page)
      limit: if req.query.limit? then parseInt(req.query.limit) else 10
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

      res.render 'alarms',
      alarms: lists
      isStart: isStart
      isEnd: isEnd
      prevPage: prevPage
      nextPage: nextPage
      title: "Alarms - Coffee alarm"

module.exports = router
