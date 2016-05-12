mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/alarm-doc'
module.exports = mongoose
