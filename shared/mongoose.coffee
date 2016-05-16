require('dotenv').config()
mongoose = require 'mongoose'
mongoose.connect 'mongodb://'+process.env.MONGO_HOST+'/alarm-doc'
module.exports = mongoose
