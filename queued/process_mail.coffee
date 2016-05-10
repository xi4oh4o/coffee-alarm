kue = require('kue')
queue = kue.createQueue()

email = (data, done) ->
  console.log data
  # email send stuff...
  done()
  return

queue.process 'email', 20, (job, done) ->
  email job.data, done
  return
